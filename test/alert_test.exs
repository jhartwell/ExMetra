defmodule ExMetra.AlertTest do
  use ExUnit.Case

  @id "63f1a503-1fd6-4a1e-8cf6-3057536ca2be"
  @is_deleted false
  @trip_update "null"
  @vehicle "null"
  @start_time "2017-11-23T11:59:55.000Z"
  @end_time "2018-03-07T09:00:00.000Z"
  @route "UP-W"
  @trip "ABC"
  @stop_id "CHICAGO"
  @header "Metra Alert"
  @description "This is a test"

  @json """
  {
    	"id": "#{@id}",
    	"is_deleted": "#{@is_deleted}",
    	"trip_update": "#{@trip_update}",
    	"vehicle": "#{@vehicle}",
    	"alert": {
    		"active_period": [{
    				"start": {
    					"low": "#{@start_time}",
    					"high": 0,
    					"unsigned": true
    				},
    				"end": {
    					"low": "#{@end_time}",
    					"high": 0,
    					"unsigned": true
    				}
    			}
    		],
    		"informed_entity": [{
    				"agency_id": null,
    				"route_id": "#{@route}",
    				"route_type": null,
    				"trip": "#{@trip}",
    				"stop_id": "#{@stop_id}"
    			}
    		],
    		"cause": 1,
    		"effect": 8,
    		"url": {
    			"translation": [{
    					"text": "http://metrarail.com/metra/en/home.html?Twitter=0&Website=1&OnBoard=0&Email=1",
    					"language": "en-US"
    				}
    			]
    		},
    		"header_text": {
    			"translation": [{
    					"text": "#{@header}",
    					"language": "en-US"
    				}
    			]
    		},
    		"description_text": {
    			"translation": [{
    					"text": "#{@description}",
    					"language": "en-US"
    				}
    			]
    		}
    	}
    }
    """

  test "valid alert parsing" do
    json = Poison.Parser.parse!(@json)
    alert = ExMetra.Alert.from_json(json)
    assert @route == alert.route_id
    assert @description == alert.description
    assert @header == alert.header
    assert @id == alert.id
    assert @is_deleted == alert.is_deleted
    assert ExMetra.Utilities.to_datetime!(@end_time) == alert.alert_end
    assert ExMetra.Utilities.to_datetime!(@start_time) == alert.alert_start
    assert @stop_id == alert.stop_id
    assert @trip == alert.trip
    assert @trip_update == alert.trip_update
    assert @vehicle == alert.vehicle
  end
end