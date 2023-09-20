view: new_customer_each_month_trend {
  derived_table: {
    sql: WITH monthly_customers AS (
        SELECT FORMAT_DATE('%b-%Y', FirstOrderDate) AS month, FORMAT_DATE('%Y-%m', FirstOrderDate) AS month_year, COUNT(*) AS New_Customers
        FROM (
          SELECT CustomerKey, MIN(OrderDate) AS FirstOrderDate
          FROM Sales S
          GROUP BY CustomerKey
        ) oc
        GROUP BY month_year, month
      ),
      ranked_customers AS (
        SELECT month, month_year, New_Customers,
          ROW_NUMBER() OVER (ORDER BY month_year, month) AS rank, COUNT(*) OVER () AS total_count
        FROM monthly_customers
      )
      SELECT month, month_year, New_Customers, rank,
      CASE WHEN rank =total_count  THEN NULL ELSE New_Customers END AS Last_Value_Column1,
        CASE WHEN rank < total_count THEN NULL ELSE New_Customers END AS Last_Value_Column2
      FROM ranked_customers
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: month {
    type: string
    sql: ${TABLE}.month ;;
  }

  dimension: month_year {
    type: string
    sql: ${TABLE}.month_year ;;
  }

  dimension: new_customers {
    type: number
    sql: ${TABLE}.New_Customers ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: last_value_column1 {
    type: number
    sql: ${TABLE}.Last_Value_Column1 ;;
  }

  dimension: last_value_column2 {
    type: number
    sql: ${TABLE}.Last_Value_Column2 ;;
  }

  set: detail {
    fields: [
      month,
      month_year,
      new_customers,
      rank,
      last_value_column1,
      last_value_column2
    ]
  }
}
