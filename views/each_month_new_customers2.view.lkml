view: each_month_new_customers2 {
  derived_table: {
    sql: select FORMAT_DATE('%b-%Y', FirstOrderDate) AS month,FORMAT_DATE('%Y-%m', FirstOrderDate) AS month_year, count(*) as New_Customers
      from (select CustomerKey, min(OrderDate) as FirstOrderDate
      from  Sales S
      group by CustomerKey
      ) oc
      group by month_year,month;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: month_year {
    type: string
    sql: ${TABLE}.month_year ;;
  }
  dimension: month {
    type: string
    sql: ${TABLE}.month ;;
  }
  dimension: new_customers {
    type: number
    sql: ${TABLE}.New_Customers ;;
  }


  set: detail {
    fields: [month,month_year, new_customers]
  }
}
