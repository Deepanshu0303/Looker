view: new_joiners3 {
  derived_table: {
    sql: WITH
      new_joiners_2 AS (select count(*) as New_joined_customers  from (SELECT C.CustomerKey, C.gender,MIN(S.OrderDate) as Aquisition_Customer_Date FROM
            my-first-project-2023-376710.Sales_dataset.Sales S
            LEFT JOIN
            my-first-project-2023-376710.Sales_dataset.Customers C
            ON
            S.CustomerKey = C.CustomerKey
            where
            1=1 -- no filter on 'new_joiners_2.gender_filter'

      GROUP BY C.CustomerKey,C.gender
      HAVING MIN(S.OrderDate)>= DATE_TRUNC(Date( {% parameter select_reference_date %}),MONTH)
      AND MIN(S.OrderDate)< DATE_TRUNC(DATE_ADD(Date( {% parameter select_reference_date %}), interval 1 month),MONTH))
      ),
      total_customers_month AS (
      SELECT COUNT(*) AS Total_customers
      FROM my-first-project-2023-376710.Sales_dataset.Sales S
      WHERE S.OrderDate>= DATE_TRUNC(Date( {% parameter select_reference_date %}),MONTH)
      AND S.OrderDate< DATE_TRUNC(DATE_ADD(Date({% parameter select_reference_date %}), interval 1 month),MONTH))


      SELECT
      new_joiners_2.New_joined_customers  AS new_joiners_2_new_joined_customers,total_customers_month.Total_customers AS total_customers
      FROM new_joiners_2
      CROSS JOIN
      total_customers_month

      ;;
  }
  parameter: select_reference_date {
    type: date
    convert_tz: no
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: new_joiners_2_new_joined_customers {
    type: number
    sql: ${TABLE}.new_joiners_2_new_joined_customers ;;
  }

  measure: total_customers {
    type: number
    sql: ${TABLE}.total_customers ;;
  }


  set: detail {
    fields: [new_joiners_2_new_joined_customers, total_customers]
  }
}
