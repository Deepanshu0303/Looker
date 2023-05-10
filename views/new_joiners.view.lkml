view: new_joiners {
  derived_table: {
    sql: (select count(*) as New_joined_customers  from (SELECT C.CustomerKey, C.gender,MIN(S.OrderDate) as Aquisition_Customer_Date FROM
      my-first-project-2023-376710.Sales_dataset.Sales S
      LEFT JOIN
      my-first-project-2023-376710.Sales_dataset.Customers C
      ON
      S.CustomerKey = C.CustomerKey
      where {% condition gender %} C.gender {% endcondition %}
      GROUP BY C.CustomerKey,C.gender
      HAVING MIN(S.OrderDate)>= DATE_TRUNC(Date( {% parameter parameters.select_reference_date %}),MONTH)
      AND MIN(S.OrderDate)< DATE_TRUNC(DATE_ADD(Date( {% parameter parameters.select_reference_date %}), interval 1 month),MONTH)))
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }
  dimension: gender {
    type: string
    sql: ${TABLE}.Gender ;;
  }
  dimension: new_joined_customers {
    type: number
    sql: ${TABLE}.New_joined_customers ;;
  }

  set: detail {
    fields: [new_joined_customers]
  }
}
