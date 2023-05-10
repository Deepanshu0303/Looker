# The name of this view in Looker is "Flights"
view: flights {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `Airport.Flights`
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Arr Delay" in Explore.

  dimension: arr_delay {
    label: "arr_delay"
    type: number
    sql: ${TABLE}.ArrDelay ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_arr_delay {
    label: "total_arr_delay"
    type: sum
    sql: ${arr_delay} ;;
  }

  measure: average_arr_delay {
    label: "average_arr_delay"
    type: average
    sql: ${arr_delay} ;;
  }

  dimension: carrier {
    label: "carrier"
    type: string
    sql: ${TABLE}.Carrier ;;
  }

  dimension: day_of_week {
    label: "day_of_week"
    type: number
    sql: ${TABLE}.DayOfWeek ;;
  }

  dimension: dayof_month {
    label: "dayof_month"
    type: number
    sql: ${TABLE}.DayofMonth ;;
  }

  dimension: dep_delay {

    type: number
    sql: ${TABLE}.DepDelay ;;
  }

  dimension: dest_airport_id {
    type: number
    sql: ${TABLE}.DestAirportID ;;
  }

  dimension: origin_airport_id {
    label: "origin_airport_id"
    type: number
    sql: ${TABLE}.OriginAirportID ;;
  }

  measure: count {
    label: "count"
    type: count
    drill_fields: []
  }
}
