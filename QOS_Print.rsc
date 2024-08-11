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
