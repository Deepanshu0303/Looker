# The name of this view in Looker is "Returns"
view: returns {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `Sales_dataset.Returns`
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Product Key" in Explore.

  dimension: product_key {
    type: number
    sql: ${TABLE}.ProductKey ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_product_key {
    type: sum
    sql: ${product_key} ;;
  }

  measure: average_product_key {
    type: average
    sql: ${product_key} ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: return {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ReturnDate ;;
  }

  dimension: return_quantity {
    type: number
    sql: ${TABLE}.ReturnQuantity ;;
  }
  measure: total_return_quantity {
    type: sum
    sql: COALESCE(${return_quantity},0);;
  }
  measure: total_return_Sales {
    type: sum
    sql: COALESCE(${return_quantity}*${products.product_price},0) ;;
  }

  dimension: territory_key {
    type: number
    sql: ${TABLE}.TerritoryKey ;;
  }

  dimension: current_vs_previous_period_bigquery_return {
    description: "Use this dimension along with \"Select Timeframe\" Filter"
    type: string
    sql:
    CASE
      WHEN DATE_TRUNC(cast(${return_date} as timestamp),  month) = DATE_TRUNC({% if parameters.select_reference_date._is_filtered %}{% parameter parameters.select_reference_date %} {% else %} ${parameters.current_timestamp_date}{% endif %},month)
        THEN '{% if parameters.select_reference_date._is_filtered %}Reference {% else %}Current {% endif %} Month'
      WHEN DATE_TRUNC(${return_date},  month) = DATE_TRUNC(DATE_SUB(Date({% if parameters.select_reference_date._is_filtered %}{% parameter parameters.select_reference_date %} {% else %} ${parameters.current_timestamp_date}{% endif %}), INTERVAL 1 month), month)
        THEN "Previous Month"
      ELSE NULL
    END
    ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
