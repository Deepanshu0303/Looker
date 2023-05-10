# The name of this view in Looker is "Airports"
view: airports {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `Airport.Airports`
    ;;
  drill_fields: [airport_id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: airport_id {
    label: "Airport_Id"
    primary_key: yes
    type: number
    sql: ${TABLE}.airport_id ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "City" in Explore.

  dimension: city {
    label: "city"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: name {
    label: "name"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: state {
    label: "state"
    type: string
    sql: ${TABLE}.state ;;
  }
  dimension: Type_of_state{
    label: "Typeof_state"
    type: string
    sql: CASE
         WHEN ${TABLE}.state = 'AK' THEN '{{ _localization['home_state'] }}'
         ELSE '{{ _localization['other_state'] }}'
         END;;
  }
  measure: count {
    label: "count"
    type: count
    drill_fields: [airport_id, name]
  }
}
