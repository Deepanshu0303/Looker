view: new_customer_joined {
  derived_table: {
    sql: select * from ((SELECT C.CustomerKey, MIN(S.OrderDate) as Aquisition_Customer_Date FROM
      my-first-project-2023-376710.Sales_dataset.Sales S
      LEFT JOIN
      my-first-project-2023-376710.Sales_dataset.Customers C
      ON
      S.CustomerKey = C.CustomerKey
      GROUP BY C.CustomerKey
      HAVING MIN(S.OrderDate)>= DATE_TRUNC(Date( {% parameter parameters.select_reference_date %}),MONTH)
      AND MIN(S.OrderDate)< DATE_TRUNC(DATE_ADD(Date( {% parameter parameters.select_reference_date %}), interval 1 month),MONTH)) cross join (select count(*) as New_joined_customers from (SELECT C.CustomerKey, MIN(S.OrderDate) as Aquisition_Customer_Date FROM
      my-first-project-2023-376710.Sales_dataset.Sales S
      LEFT JOIN
      my-first-project-2023-376710.Sales_dataset.Customers C
      ON
      S.CustomerKey = C.CustomerKey
      GROUP BY C.CustomerKey
      HAVING MIN(S.OrderDate)>= DATE_TRUNC(Date( {% parameter parameters.select_reference_date %}),MONTH)
      AND MIN(S.OrderDate)< DATE_TRUNC(DATE_ADD(Date({% parameter parameters.select_reference_date %}), interval 1 month),MONTH))))
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: customer_key {
    type: number
    sql: ${TABLE}.CustomerKey ;;
  }

  dimension: aquisition_customer_date {
    type: date
    datatype: date
    sql: ${TABLE}.Aquisition_Customer_Date ;;
  }

  dimension: new_joined_customers {
    type: number
    sql: ${TABLE}.New_joined_customers ;;
  }

  set: detail {
    fields: [customer_key, aquisition_customer_date, new_joined_customers]
  }
}
