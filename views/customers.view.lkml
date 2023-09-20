# The name of this view in Looker is "Customers"
view: customers {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `Sales_dataset.Customers`
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Annual Income" in Explore.

  dimension: annual_income {
    type: number
    sql: ${TABLE}.AnnualIncome ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_annual_income {
    type: sum
    sql: ${annual_income} ;;
  }

  measure: average_annual_income {
    type: average
    sql: ${annual_income} ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: birth {
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
    sql: ${TABLE}.BirthDate ;;
  }
  dimension: Age {
    type: number
    sql: DATE_DIFF(DATE_TRUNC(DATE({% parameter parameters.select_reference_date %}), YEAR), DATE(${birth_date}), YEAR)
;;
  }
  dimension: Age_tier {
    type: tier
    tiers: [30,40,50,60,70,80,90,100,110 ]
    style: integer
    sql: ${Age} ;;
  }
  dimension: Annual_Income_tier {
    type: tier
    tiers: [10000,20000,30000,40000,50000,60000,70000,80000,90000,100000,110000,120000,130000,140000,150000,160000,170000,180000 ]
    style: integer
    value_format: "$#,##0,\" K\""
    sql: ${annual_income} ;;
  }
#"$#,##0.00,\" K\""
  dimension: customer_key {
    primary_key: yes
    type: number
    sql: ${TABLE}.CustomerKey ;;
  }
  measure: Total_customers {
    type: count_distinct
    sql: ${customer_key};;
  }



  dimension: education_level {
    type: string
    sql: ${TABLE}.EducationLevel ;;
  }

  dimension: email_address {
    type: string
    sql: ${TABLE}.EmailAddress ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.FirstName ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.Gender ;;
  }

  dimension: home_owner {
    type: yesno
    sql: ${TABLE}.HomeOwner ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.LastName ;;
  }

  dimension: marital_status {
    type: string
    sql: ${TABLE}.MaritalStatus ;;
  }

  dimension: occupation {
    type: string
    sql: ${TABLE}.Occupation ;;
  }

  dimension: prefix {
    type: string
    sql: ${TABLE}.Prefix ;;
  }

  dimension: total_children {
    type: number
    sql: ${TABLE}.TotalChildren ;;
  }
  measure: total_Sales3 {
    type: sum
    value_format: "$#,##0.00"
    sql: ${sales.order_quantity}*${products.product_price} ;;


  }
  #html: {{ rendered_value }} | Customer Name: {{ customers.first_name._rendered_value | concat: ' ' | append: customers.last_name._rendered_value }}   ;;
#{{ rendered_value }} | CustomerKey: {{customer_key._rendered_value }}
# html: { rendered_value }} | Customer_Name: {{ first_name._rendered_value | concat: ' ' | append: last_name._rendered_value }}   ;;
  measure: count {
    type: count
    drill_fields: [first_name, last_name]
  }
}
