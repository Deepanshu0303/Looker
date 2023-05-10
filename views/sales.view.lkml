# The name of this view in Looker is "Sales"
view: sales {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `Sales_dataset.Sales`
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Customer Key" in Explore.

  dimension: customer_key {
    type: number
    sql: ${TABLE}.CustomerKey ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.



  measure: average_customer_key {
    type: average
    sql: ${customer_key} ;;
  }


  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: order {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day,
      day_of_week,
      month_name,
      day_of_month,
      month_num,day_of_week_index,
      day_of_year,
      quarter_of_year
]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.OrderDate ;;
  }
  dimension_group: current_timestamp {
    hidden: yes
    type: time
    timeframes: [raw,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day,
      day_of_week,
      month_name,
      day_of_month,
      month_num,day_of_week_index,
      day_of_year,
      quarter_of_year]
    convert_tz: yes
    #sql: current_timestamp ;; #### SNOWFLAKE
    sql: CURRENT_TIMESTAMP() ;; #### BIGQUERY
#     sql: GETDATE() ;; #### REDSHIFT
  }
  dimension: current_vs_previous_period_bigquery {
    description: "Use this dimension along with \"Select Timeframe\" Filter"
    type: string
    sql:
    CASE
      WHEN DATE_TRUNC(cast(${order_date} as timestamp),  month) = DATE_TRUNC({% if parameters.select_reference_date._is_filtered %}{% parameter parameters.select_reference_date %} {% else %} ${parameters.current_timestamp_date}{% endif %},month)
        THEN '{% if parameters.select_reference_date._is_filtered %}Reference {% else %}Current {% endif %} Month'
      WHEN DATE_TRUNC(${order_date},  month) = DATE_TRUNC(DATE_SUB(Date({% if parameters.select_reference_date._is_filtered %}{% parameter parameters.select_reference_date %} {% else %} ${parameters.current_timestamp_date}{% endif %}), INTERVAL 1 month), month)
        THEN "Previous Month"
      ELSE NULL
    END
    ;;
  }

 # dimension: selected_dynamic_day_of  {
  #  label: "{%
   # if parameters.select_timeframe._is_filtered and parameters.select_timeframe._parameter_value == 'month' %}Day of Month{%
  #  elsif parameters.select_timeframe._is_filtered and parameters.select_timeframe._parameter_value == 'week' %}Day of Week{%
   # elsif parameters.select_timeframe._is_filtered and parameters.select_timeframe._parameter_value == 'day' %}Hour of Day{%
    #elsif parameters.select_timeframe._is_filtered and parameters.select_timeframe._parameter_value == 'year' %}Months{%
    #else %}Selected Dynamic Timeframe Granularity{%
    #endif %}"
  #  order_by_field: selected_dynamic_day_of_sort
  #  type: string
  #  sql:
  #  {% if parameters.select_timeframe._parameter_value == 'day' %}
  #    ${order_hour_of_day}
   # {% elsif parameters.select_timeframe._parameter_value == 'week' %}
  #   ${order_day_of_week}
  #  {% elsif parameters.select_timeframe._parameter_value == 'year' %}
  ##    ${order_month_name}
  ##   ${order_day_of_month}
  #  {% endif %}
  #  ;;
  #}



  #dimension: is_to_date {
  #  hidden: yes
   # type: yesno
  #  sql:
   #   {% if parameters.apply_to_date_filter._parameter_value == 'true' %}
    #    {% if parameters.select_timeframe._parameter_value == 'week' %}
     ##  {% elsif parameters.select_timeframe._parameter_value == 'day' %}
      #    ${order_hour_of_day} <= $current_timestamp_hour_of_day}
      #  {% elsif parameters.select_timeframe._parameter_value == 'year' %}
      #    ${order_day_of_year} <= ${current_timestamp_day_of_year}
      #  {% else %}
      #    ${order_day_of_month} <= ${current_timestamp_day_of_month}
      #  {% endif %}
      #{% else %} true
      #{% endif %}
    #;;
  #}

  dimension: is_to_date2 {
    hidden: yes
    type: yesno
    sql:
      {% if parameters.apply_to_date_filter._parameter_value == 'true' %}
        {% if parameters.select_timeframe._parameter_value == 'week' %}
          ${order_day_of_week_index} <= (MOD((EXTRACT(DAYOFWEEK from {% parameter parameters.select_reference_date %})-1) - 1 + 7, 7))
        {% elsif parameters.select_timeframe._parameter_value == 'day' %}
          ${order_hour_of_day} <=EXTRACT(HOUR FROM TIMESTAMP({% parameter parameters.select_reference_date %}))
        {% elsif parameters.select_timeframe._parameter_value == 'year' %}
          ${order_day_of_year} <=  EXTRACT(DAYOFYEAR FROM {% parameter parameters.select_reference_date %})
        {% elsif parameters.select_timeframe._parameter_value == 'quarter' %}
           (${order_date}<= Date({% parameter parameters.select_reference_date %}) and  ${order_date}>= DATE_TRUNC(Date({% parameter parameters.select_reference_date %}), Quarter)) or (${order_date}>= DATE_TRUNC(DATE_SUB(Date({% parameter parameters.select_reference_date %}), INTERVAL 1 Quarter),Quarter) and ${order_date}<=DATE_SUB(Date({% parameter parameters.select_reference_date %}), INTERVAL 1 Quarter))
        {% else %}
          ${order_day_of_month} <= EXTRACT(DAY FROM {% parameter parameters.select_reference_date %})
        {% endif %}
      {% else %} true
      {% endif %}
    ;;
  }

  dimension: is_to_date3{
    hidden: yes
    type: yesno
    sql:
      {% if parameters.apply_to_date_filter._parameter_value == 'true' %}
        {% if parameters.select_timeframe._parameter_value == 'week' %}
          ${order_day_of_week_index} <= (MOD((EXTRACT(DAYOFWEEK from {% parameter parameters.select_reference_date %})-1) - 1 + 7, 7))
        {% elsif parameters.select_timeframe._parameter_value == 'day' %}
          ${order_hour_of_day} <=EXTRACT(HOUR FROM TIMESTAMP({% parameter parameters.select_reference_date %}))
        {% elsif parameters.select_timeframe._parameter_value == 'year' %}
          ${order_day_of_year} <=  EXTRACT(DAYOFYEAR FROM {% parameter parameters.select_reference_date %})
        {% elsif parameters.select_timeframe._parameter_value == 'quarter' %}
           (${order_date}<= Date({% parameter parameters.select_reference_date %}) and  ${order_date}>= DATE_TRUNC(Date({% parameter parameters.select_reference_date %}), Quarter)) or (${order_date}>= DATE_TRUNC(DATE_SUB(Date({% parameter parameters.select_reference_date %}), INTERVAL 1 year),Quarter) and ${order_date}<=DATE_SUB(Date({% parameter parameters.select_reference_date %}), INTERVAL 1 year))
        {% else %}
          ${order_day_of_month} <= EXTRACT(DAY FROM {% parameter parameters.select_reference_date %})
        {% endif %}
      {% else %} true
      {% endif %}
    ;;
  }

  dimension: created_month_of_quarter {
    label: "Created Month of Quarter"
    group_label: "Created Date"  ### Change to match your time dimension group label
    group_item_label: "Month of Quarter"
    type: string
    sql:
      case
        when ${order_month_num} IN (1,4,7,10) then 1
        when ${order_month_num} IN (2,5,8,11) then 2
        else 3
      end
    ;;
  }

  dimension: selected_dynamic_timeframe  {
    label_from_parameter: parameters.select_timeframe
    description: "Use this dimension alongside the \"Select Timeframe\" filter to be able to dynamically change between the date, week, month, quarter or year dimensions"
    alias: [dynamic_timeframe]
    type: string
    sql:
    {% if parameters.select_timeframe._parameter_value == 'day' %}
      ${order_date}
    {% elsif parameters.select_timeframe._parameter_value == 'week' %}
      ${order_week}
    {% elsif parameters.select_timeframe._parameter_value == 'year' %}
      ${order_year}
    {% elsif parameters.select_timeframe._parameter_value == 'quarter' %}
      ${order_quarter}
    {% else %}
      ${order_month}
    {% endif %}
    ;;
  }

  dimension: selected_dynamic_day_of_sort  {
    hidden: yes
    label_from_parameter: parameters.select_timeframe
    type: number
    sql:
    {% if parameters.select_timeframe._parameter_value == 'day' %}
      ${order_hour_of_day}
    {% elsif parameters.select_timeframe._parameter_value == 'week' %}
      ${order_day_of_week_index}
    {% elsif parameters.select_timeframe._parameter_value == 'year' %}
      ${order_month_num}
    {% elsif parameters.select_timeframe._parameter_value == 'quarter' %}
      ${order_month_num}
    {% else %}
      ${order_day_of_month}
    {% endif %}
    ;;
  }

  dimension: selected_dynamic_day_of  {
    view_label: " TOTT | Current vs Previous - Quarter"
    label: "{%
    if parameters.select_timeframe._is_filtered and parameters.select_timeframe._parameter_value == 'month' %}Day of Month{%
    elsif parameters.select_timeframe._is_filtered and parameters.select_timeframe._parameter_value == 'week' %}Day of Week{%
    elsif parameters.select_timeframe._is_filtered and parameters.select_timeframe._parameter_value == 'day' %}Hour of Day{%
    elsif parameters.select_timeframe._is_filtered and parameters.select_timeframe._parameter_value == 'year' %}Months{%
    elsif parameters.select_timeframe._is_filtered and parameters.select_timeframe._parameter_value == 'quarter' %}Quarter of Year{%
    else %}Dynamic Timeframe Granularity{%
    endif %}"
    description: "Use this dimension alonside the \"Select Timeframe\" filter to be able to analyze data with a dynamic granularity (hour of day, day of week/month, month of year)"
    order_by_field:selected_dynamic_day_of_sort
    type: string
    sql:
      {% if parameters.select_timeframe._parameter_value == 'day' %}
        ${order_hour_of_day}
      {% elsif parameters.select_timeframe._parameter_value == 'week' %}
        ${order_day_of_week}
      {% elsif parameters.select_timeframe._parameter_value == 'year' %}
        ${order_month_name}
      {% elsif parameters.select_timeframe._parameter_value == 'quarter' %}
        ${order_month_num}
      {% else %}
        ${order_day_of_month}
      {% endif %}
    ;;
  }
  dimension: selected_reference_date_default_today_bigquery {
    description: "This Dimension will make sure that when \"Select Reference date\" is set in  the future then we use the current day for reference"
    type: date_raw
    sql:
    CASE
      WHEN {% parameter parameters.select_reference_date %} IS NULL OR ${current_timestamp_date} <= DATE({% parameter parameters.select_reference_date %})
        THEN ${current_timestamp_date}
      ELSE DATE({% parameter parameters.select_reference_date %})
      END
    ;;
  }
  dimension: dynamic_labels_in_liquid_with_quarter_bigquery {
    ## This Dimension will generate the correct label between \"Current <timeframe>\" and \"Reference <timeframe>\" only using liquid so not impacting performance
    type: string
    hidden: yes
    sql:
    {% assign current = "now" %}
    {% assign reference = parameters.select_reference_date._parameter_value | remove: "TIMESTAMP('" | remove: "')" | remove : " 00:00:00" | append : " 00:00:00" %}
    {% assign current_label = "Current " | append : parameters.select_timeframe._parameter_value %}
    {% assign reference_label = "Reference " | append : parameters.select_timeframe._parameter_value %}
    {% if parameters.select_timeframe._parameter_value == 'day' %}
      {% assign current = current | date: "%Y-%m-%d" %}
      {% assign reference = reference | date: "%Y-%m-%d" %}
        {% if reference >= current %}
        'Hours of {{ current_label }} ({{ current }})'
        {% else %} 'Hours of {{ reference_label }} ({{ reference }})'
        {% endif %}
    {% elsif parameters.select_timeframe._parameter_value == 'week' %}
      {% assign current_year = current | date: "%Y" %}
      {% assign reference_year = reference | date: "%Y" %}
      {% assign current = current | date: "%W" %}
      {% assign reference = reference | date: "%W" %}
        {% if reference >= current %}
        'Days of {{ current_label }} (W{{ current }} - {{ current_year }})'
        {% else %} 'Days of {{ reference_label }} (W{{ reference }} - {{ reference_year }})'
        {% endif %}
    {% elsif parameters.select_timeframe._parameter_value == 'month' %}
      {% assign current = current | date: "%Y-%m" %}
      {% assign reference = reference | date: "%Y-%m" %}
        {% if reference >= current %}
        'Days of {{ current_label }} ({{ current }})'
        {% else %} 'Days of {{ reference_label }} ({{ reference }})'
        {% endif %}
    {% elsif parameters.select_timeframe._parameter_value == 'quarter' %}
      {% assign current_year = current | date: "%Y" %}
      {% assign reference_year = reference | date: "%Y" %}
      {% assign current_month = current | date: "%m" %}
      {% assign reference_month = reference | date: "%m" %}
      {% assign current_quarter = current_month | divided_by: 3.0 | ceil %}
      {% assign reference_quarter = reference_month | divided_by: 3.0 | ceil %}
        {% if reference_year >= current_year and reference_quarter >= current_quarter %}
         'Month of {{ current_label }} (Q{{ current_quarter }}-{{ current_year }})'
        {% else %}'Month of {{ reference_label }} (Q{{ reference_quarter }}-{{ reference_year }})'
        {% endif %}
    {% elsif parameters.select_timeframe._parameter_value == 'year' %}
      {% assign current = current | date: "%Y" %}
      {% assign reference = reference | date: "%Y" %}
        {% if reference >= current %}
        'Month of {{ current_label }} ({{ current }})'
        {% else %} 'Month of {{ reference_label }} ({{ reference }})'
        {% endif %}
    {% else %} 'error in parameters.dynamic_labels_in_liquid [{{ current_label }} ({{ current }}) / {{ reference_label }} ({{ reference }})]'
    {% endif %}
  ;;
  }



  dimension: current_vs_previous_period_bigquery2 {
    label: "Current vs Previous Period"
    description: "Use this dimension along with \"Select Timeframe\" Filter (Liquid Labels + default to today)"
    type: string
    sql:
      CASE
        WHEN DATE_TRUNC(${order_date},  {% parameter parameters.select_timeframe %}) = DATE_TRUNC(${selected_reference_date_default_today_bigquery}, {% parameter parameters.select_timeframe %})
          THEN ${dynamic_labels_in_liquid_with_quarter_bigquery}
        WHEN DATE_TRUNC(${order_date},  {% parameter parameters.select_timeframe %}) = DATE_TRUNC(DATE_SUB(${selected_reference_date_default_today_bigquery}, INTERVAL 1 {% parameter parameters.select_timeframe %}), {% parameter parameters.select_timeframe %})
          THEN concat(${parameters.temp}," ","Previous {% parameter parameters.select_timeframe %}")
        ELSE NULL
      END
      ;;
  }

  dimension: current_vs_previous_period_bigquery3 {
    label: "Current vs Previous Period2"
    description: "Use this dimension along with \"Select Timeframe\" Filter (Liquid Labels + default to today)"
    type: string
    sql:
     {% if parameters.select_timeframe._parameter_value == 'quarter' %}
      CASE
        WHEN DATE_TRUNC(${order_date}, quarter) = DATE_TRUNC(${selected_reference_date_default_today_bigquery}, quarter)
          THEN ${dynamic_labels_in_liquid_with_quarter_bigquery}
        WHEN DATE_TRUNC(${order_date},  quarter) = DATE_TRUNC(DATE_SUB(${selected_reference_date_default_today_bigquery}, INTERVAL 1 year), quarter)
          THEN concat(${parameters.temp}," ","same quarter of last year")
        ELSE NULL
      END


    {% else %}
      CASE
        WHEN DATE_TRUNC(${order_date},  {% parameter parameters.select_timeframe %}) = DATE_TRUNC(${selected_reference_date_default_today_bigquery}, {% parameter parameters.select_timeframe %})
          THEN ${dynamic_labels_in_liquid_with_quarter_bigquery}
        WHEN DATE_TRUNC(${order_date},  {% parameter parameters.select_timeframe %}) = DATE_TRUNC(DATE_SUB(${selected_reference_date_default_today_bigquery}, INTERVAL 1 {% parameter parameters.select_timeframe %}), {% parameter parameters.select_timeframe %})
          THEN concat(${parameters.temp}," ","Previous {% parameter parameters.select_timeframe %}")
        ELSE NULL
      END
    {% endif %}
      ;;
  }




dimension: order_line_item {
    type: number
    sql: ${TABLE}.OrderLineItem ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.OrderNumber ;;
  }

  dimension: order_quantity {
    type: number
    sql: ${TABLE}.OrderQuantity ;;
  }
  measure: total_Sales {
    type: sum
    sql: ${order_quantity}*${products.product_price} ;;
  }

  measure: total_Cost {
    type: sum
    sql: ${order_quantity}*${products.product_cost} ;;
  }
  measure: total_order_quantity {
    type: sum
    sql: ${order_quantity} ;;
  }

  dimension: product_key {
    type: number
    sql: ${TABLE}.ProductKey ;;
  }
  measure: Total_customers {
    type: count_distinct
    sql: ${customer_key};;
  }
  measure: Average_Order_Per_Customer {
    type: number
    sql: ${count}/${Total_customers};;
  }



  dimension_group: stock {
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
    sql: ${TABLE}.StockDate ;;
  }

  dimension: territory_key {
    type: number
    sql: ${TABLE}.TerritoryKey ;;
  }
  measure:profit  {
    type: number
    sql: ${total_Sales}-${total_Cost} ;;
  }
  measure: profit_margin {
    type: number
    #value_format: "0\%"
    sql: ${profit}/${total_Sales} ;;
  }
  measure: sales_per_customer {
    type: number
    value_format: "0.000,\" K\""
    sql: ${total_Sales}/${Total_customers} ;;
  }

  measure:average_order_value  {
    type: number
    value_format: "0.000,\" K\""
    sql: ${total_Sales}/${total_order_quantity} ;;
  }
  parameter: Select_KPI {
    type: unquoted
    #default_value: "total_Sales"
    allowed_value: {
      label: "Sale Price"
      value: "total_Sales"
    }
    allowed_value: {
      label: "Profit"
      value: "profit"
    }
    allowed_value: {
      label: "Profit Margin"
      value: "profit_margin"
    }
    allowed_value: {
      label: "Quantity"
      value: "total_order_quantity"
    }
    allowed_value: {
      label: "Sales Per Customer"
      value: "sales_per_customer"
    }
    allowed_value: {
      label: "Average Order Value"
      value: "average_order_value"
    }
    allowed_value: {
      label: "Cost"
      value: "cost"
    }
}









  measure:KPI {
    label_from_parameter: Select_KPI
    type: number
    sql:
    {% if Select_KPI._parameter_value == 'total_Sales' %}
      ${total_Sales}
    {% elsif Select_KPI._parameter_value == 'profit' %}
      ${profit}
    {% elsif Select_KPI._parameter_value == 'profit_margin' %}
      ${profit_margin}
    {% elsif Select_KPI._parameter_value == 'total_order_quantity' %}
      ${total_order_quantity}
    {% elsif Select_KPI._parameter_value == 'sales_per_customer' %}
      ${sales_per_customer}
    {% elsif Select_KPI._parameter_value == 'cost' %}
      ${total_Cost}
    {% else %}
      ${average_order_value}
    {% endif %};;
  }
  dimension: title {
    type: string
    sql: CONCAT(INITCAP("{% parameter parameters.select_timeframe %}")," ","vs"," ",INITCAP("{% parameter Select_KPI %}")) ;;
    html: <h3>{{rendered_value}}</h3> ;;
  }

  dimension: title_prod {
    type: string
    sql: INITCAP("{% parameter Select_KPI %}") ;;
    html: <h3>Top 3 Product by {{rendered_value}}</h3> ;;
  }
  dimension: period_over_period {
    type: string
    sql:INITCAP("{% parameter Select_KPI %}");;
    html: <h3>Period over Period analysis by {{rendered_value}} </h3> ;;
  }

  dimension: title_sub {
    type: string
    sql: INITCAP("{% parameter Select_KPI %}") ;;
    html: <h3>Top 3 Subcategory by {{rendered_value}}</h3> ;;
  }
  dimension: title_cate {
    type: string
    sql: INITCAP("{% parameter Select_KPI %}") ;;
    html: <h3>Top 3 Category by {{rendered_value}}</h3> ;;
  }

  dimension: title_cat_analysis {
    type: string
    sql: INITCAP("{% parameter Select_KPI %}") ;;
    html: <h3> {{rendered_value}} by Category</h3> ;;
  }

  dimension: title_subcat_analysis {
    type: string
    sql: INITCAP("{% parameter Select_KPI %}") ;;
    html: <h3> {{rendered_value}} by Subcategory</h3> ;;
  }
  measure: count {
    type: count
    drill_fields: []
  }
  }
