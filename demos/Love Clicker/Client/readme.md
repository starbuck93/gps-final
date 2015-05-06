#Coronium GS Corona SDK Client#

##Development Setup##

###Download source###

[Download](https://bitbucket.org/develephant/coronium-gs/get/default.zip) the latest Server/Client code bundle from the bitbucket repo.

###Start Coding###

Code your Client project using the __Client/main.lua__ file.  You should not need to edit the other files under normal circumstances.

##Pretty Printing##

You can pretty print data using the Coronium GS Client method.
    local gs = require( 'gs.CoroniumGSClient' ):new()
    local p = gs.p --== Pretty Printer

    p( table_data )

Or via the Utils module:

    local p = require( 'gs.Utils' ).p
    p( table_data )

##Events/Emitters##

###Event listeners###

####Add event listener####

    gs.events:on( "EventName", onEventCallback )

###Creating custom events###

####Create 'emitting' module####

    local my_mod = {}

    my_mod.events = require( 'gs.EventDispatcher' )()

    function my_mod:doSomething()
      -- Emit event
      self.events:emit( "SomeEventName", someEventData )
    end

    return my_mod

####Create listener####

    --== load pretty printer
    local p = require( 'gs.Utils' ).p

    local mod = require( 'my_mod' )
    
    mod.events:on( "SomeEventName", function( someEventData )
      --Do something with the event data
      p( someEventData.someDataKey )
    end)

    mod:doSomething()

## Community Support ##

Please visit the [community forums](http://forums.coronium.io/categories/coronium-gs) for tips and helpful topics.

