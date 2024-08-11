# Define the interface you want to toggle
:local iface "ether1-gateway"

# Prompt for user input (simulated by setting these variables)
:local delay 0
:local confirm ""

# Display prompt to set delay
{
	:put ""
	:put "================================================================================"
	:put "[?] How many seconds do you want to disable Ether1 for?"
	:put "================================================================================"	
	:put "Fun FACTS! 60 seconds = 1 minute 0.o   |   300 seconds = 5 minutes o.0"
	:put "================================================================================"	
	:local input do={:put $1;:return};
    :set delay [$input ""];
    :if (($delay = "") || ($delay < 0)) do={
        :put "Invalid input. Run script again and enter a valid number."
        :return
    }
}
# Display prompt for confirmation
{
	if ($local delay > 0) do={
	#Get delay
	{
		:put ""
		:put "================================================================================"
		:put "[?] Are you sure you want to disable Ether-1 for $delay seconds? (Y/N)"
		:put "================================================================================"
		:local input do={:put $1;:return};
		:set confirm [$input ""];
		:if ($confirm != "Y" && $confirm != "y") do={
			:put "Aborting Script!"
			:return
		}
	}
}
{
# Perform the interface toggle
:put "Disabling $iface for $delay seconds..."
/interface ethernet disable $iface

# Simulate delay using a loop
:local i 0
:while ($i < $delay) do={
    :put ("Delay: " . ($delay - $i) . " seconds remaining...")
    :delay 1s
    :set i ($i + 1)
	}
}
{
# Re-enable the interface
:put "Re-enabling $iface..."
/interface ethernet enable $iface

:put "Action completed."
}
}