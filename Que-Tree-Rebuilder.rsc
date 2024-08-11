:global sossDeviceCount 0
:global sossSpeedUp 0
:global sossSpeedDn 0
:local isQueueDisabled "yes"

# Get soss Device Count
{
	/log warning "SOSS: Let's Build A Tree!"
	
    :put ""
    :put "================================================================================"
    :put "[?] How many SIP Users should bandwidth be reserved for?"
    :put "================================================================================"
    :put ""
    :put "[0] - Entering 0 will create a disabled queue tree with limits of 300D x 30U."
    :put " #  - Count the registered devices/users in NMS and enter that number."
    :local input do={:put $1;:return};
    :set sossDeviceCount [$input ""];
    :if (($sossDeviceCount = "") || ($sossDeviceCount < 0)) do={
        :put "Invalid input. Please enter a valid number."
        :set sossDeviceCount 0
    }
}

# Get Queue Speeds
{
    # Only prompt for speeds if we have a device count
    if ($sossDeviceCount > 0) do={
        # Get Download Speed
        {
            :put ""
            :put "================================================================================"
            :put "[?] What is the DOWNLOAD speed in WHOLE megabits per second?"
            :put "================================================================================"
            :put "[i] This should be multiple of fives (5, 10, 25, 50, 100, 300, 500, 1000, etc.)"
            :local input do={:put $1;:return};
            :set sossSpeedDn [$input ""];
        }

        # Get Upload Speed
        {
            :put ""
            :put "================================================================================"
            :put "[?] What is the UPLOAD speed in WHOLE megabits per second?"
            :put "================================================================================"
            :put "[i] This should be multiple of fives (5, 10, 25, 50, 100, 300, 500, 1000, etc.)"
            :local input do={:put $1;:return};
            :set sossSpeedUp [$input ""];
        }
    } else {
        # Disable Queues But Set Up Dummy Tree for 300x30
        :set sossSpeedDn 300;
        :set sossSpeedUp 30;
    }
}

# Delete Existing Queue Trees
{
    :local existingQueueTrees [/queue tree find]
    :foreach existingQueueTree in=$existingQueueTrees do={
        /queue tree remove $existingQueueTree
    }
}

# Do Queue Math and Create Queue Tree
{
    /log warning "SOSS: Doing Queue Tree Maths"

    :local qosBalanceDn 0;
    :local qosBalanceUp 0;
    :local qosReserved (($sossDeviceCount) * 100);

    :if (($sossSpeedDn = 0) || ($sossSpeedUp = 0) || ($qosReserved = 0)) do={
        :set sossSpeedDn 300;
        :set sossSpeedUp 10;
        :set qosBalanceDn 298000;
        :set qosBalanceUp 8000;
        :set qosReserved 2000;
    } else={
        :set qosReserved ($qosReserved + 100);
        :set qosBalanceDn (($sossSpeedDn * 1000) - $qosReserved);
        :set qosBalanceUp (($sossSpeedUp * 1000) - $qosReserved);
    }

    /log error "QUEUE: qosReserved:     $qosReserved kb";
    /log error "QUEUE: qosBalanceDn:    $qosBalanceDn kb";
    /log error "QUEUE: qosBalanceUp:    $qosBalanceUp kb";
    /log error "QUEUE: sossSpeedUp:      $sossSpeedUp MB";
    /log error "QUEUE: sossSpeedDn:      $sossSpeedDn MB";

    /log warning "SOSS: Creating Queue Tree";

    /queue tree
        add max-limit=($sossSpeedUp."M") name=Outbound parent=ether1-gateway disabled=$isQueueDisabled priority=1;
        add max-limit=($sossSpeedDn."M") name=Inbound parent=bridge-LAN disabled=$isQueueDisabled priority=1;
        add limit-at=($qosReserved."k") max-limit=($sossSpeedUp."M") name=Voice-Out packet-mark=voice-out parent=Outbound priority=2 queue=default disabled=$isQueueDisabled;
        add limit-at=($qosBalanceUp."k") max-limit=($sossSpeedUp."M") name=Data-Out packet-mark=data-out,no-mark parent=Outbound priority=3 queue=default disabled=$isQueueDisabled;
        add limit-at=($qosReserved."k") max-limit=($sossSpeedDn."M") name=Voice-In packet-mark=voice-in parent=Inbound priority=2 queue=default disabled=$isQueueDisabled;
        add limit-at=($qosBalanceDn."k") max-limit=($sossSpeedDn."M") name=Data-In packet-mark=data-in,no-mark parent=Inbound priority=3 queue=default disabled=$isQueueDisabled;
}

# Enable Queue Tree
{
    /log warning "SOSS: Enabling Queue Tree";
    /queue tree enable [find]
}

# Print QoS Variables
{
    :put "Here are your QOS Variables:"

    :local outboundDataOut [/queue tree find where name="Data-Out"]
    :local outboundVoiceOut [/queue tree find where name="Voice-Out"]
    :local inboundDataIn [/queue tree find where name="Data-In"]
    :local inboundVoiceIn [/queue tree find where name="Voice-In"]

    :local outboundDataOutLimitAt [/queue tree get $outboundDataOut limit-at]
    :local outboundVoiceOutLimitAt [/queue tree get $outboundVoiceOut limit-at]
    :local inboundDataInLimitAt [/queue tree get $inboundDataIn limit-at]
    :local inboundVoiceInLimitAt [/queue tree get $inboundVoiceIn limit-at]

    :local outboundDataOutLimitAtMbps ([:tostr ([:tonum $outboundDataOutLimitAt] / 1000000)] . "." . [:pick ([:tostr ([:tonum $outboundDataOutLimitAt] % 1000000)] . "00") 0 1] . " mbps")
    :local outboundVoiceOutLimitAtMbps ([:tostr ([:tonum $outboundVoiceOutLimitAt] / 1000000)] . "." . [:pick ([:tostr ([:tonum $outboundVoiceOutLimitAt] % 1000000)] . "00") 0 1] . " mbps")
    :local inboundDataInLimitAtMbps ([:tostr ([:tonum $inboundDataInLimitAt] / 1000000)] . "." . [:pick ([:tostr ([:tonum $inboundDataInLimitAt] % 1000000)] . "00") 0 1] . " mbps")
    :local inboundVoiceInLimitAtMbps ([:tostr ([:tonum $inboundVoiceInLimitAt] / 1000000)] . "." . [:pick ([:tostr ([:tonum $inboundVoiceInLimitAt] % 1000000)] . "00") 0 1] . " mbps")

    :put ("Up Data: " . $outboundDataOutLimitAtMbps . " | Up Phones: " . $outboundVoiceOutLimitAtMbps)
    :put ("Down Data: " . $inboundDataInLimitAtMbps . " | Down Phones: " . $inboundVoiceInLimitAtMbps)
}



/log error "DEFCONF: Finished Stage 6 - Queue Trees";
/log error "DEFCONF: Starting Stage 7 - Scripts";
