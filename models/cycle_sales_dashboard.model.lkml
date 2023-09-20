# Define the database connection to be used for this model.
connection: "deepanshu_sales_connection"

# include all the views
include: "/views/**/*.view"

map_layer:Continents {
  file:"/map_layer/world-continents.json"
}
# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: cycle_sales_dashboard_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: cycle_sales_dashboard_default_datagroup

# Explores allow you to join together different views (database tables) based on the
# relationships between fields. By joining a view into an Explore, you make those
# fields available to users for data analysis.
# Explores should be purpose-built for specific use cases.

# To see the Explore you’re building, navigate to the Explore menu and select an Explore under "Cycle Sales Dashboard"

# To create more sophisticated Explores that involve multiple views, you can use the join parameter.
# Typically, join parameters require that you define the join type, join relationship, and a sql_on clause.
# Each joined view also needs to define a primary key.

explore: sales {
  sql_always_where:
  {% if sales.current_vs_previous_period_bigquery2._in_query %} ${current_vs_previous_period_bigquery2} is not null {% else %} 1=1 {% endif %}
  and
  {% if sales.current_vs_previous_period_bigquery._in_query %} ${current_vs_previous_period_bigquery} is not null {% else %} 1=1 {% endif %}
  and
  {% if sales.current_vs_previous_period_bigquery3._in_query %} ${current_vs_previous_period_bigquery3} is not null {% else %} 1=1 {% endif %}
  and
   {% if parameters.apply_to_date_filter._is_filtered %} ${sales.is_to_date3}  {% else %} 1=1 {% endif %}
;;

#AND
 # {% if parameters.apply_to_date_filter._is_filtered %} ${sales.is_to_date2}  {% else %} 1=1 {% endif %}


  join: customers {
    type: left_outer
    view_label: "customers"
    relationship: many_to_one
    sql_on: ${sales.customer_key} = ${customers.customer_key} ;;
  }
  join: new_joiners { }
  join: new_joiners_2 { }
  join: new_customers {
    type: left_outer
    relationship: one_to_one
    sql_on: ${new_customers.customer_key}=${customers.customer_key} ;;
  }
  join: new_customer_joined {
    type: left_outer
    relationship: one_to_one
    sql_on: ${new_customer_joined.customer_key}=${customers.customer_key} ;;
  }

  join: territories2 {
    type: left_outer
    view_label: "territories"
    relationship: many_to_one
    sql_on: ${sales.territory_key} = ${territories2.sales_territory_key} ;;
  }
  join: products {
    type: left_outer
    view_label: "products"
    relationship: many_to_one
    sql_on: ${sales.product_key}=${products.product_key} ;;
  }
  join: product_subcategory {
    type: left_outer
    view_label: "product_subcategory"
    relationship: many_to_one
    sql_on: ${products.product_subcategory_key} = ${product_subcategory.product_subcategory_key} ;;
  }
  join: product_category {
    type: left_outer
    view_label: "product_category"
    relationship: many_to_one
    sql_on: ${product_subcategory.product_category_key}=${product_category.product_category_key} ;;
  }
  join: calendar {
    type: left_outer
    view_label: "Calendar"
    relationship: many_to_one
    sql_on: ${sales.order_date}=${calendar.date_date} ;;
  }
  join: returns {
    type: left_outer
    view_label: "Returns"
    relationship: many_to_one
    sql_on: ${returns.product_key}=${products.product_key} ;;
  }

join: top5_customers {
  type: left_outer
  relationship: many_to_one
  sql_on: ${sales.customer_key}=${top5_customers.customer_key} ;;
}


  join: parameters {}
  join: customer_analysis_titles{}

}
explore: returns {
  label: "Returns"
  view_name: returns
  sql_always_where:{% if returns.current_vs_previous_period_bigquery_return._in_query %} ${current_vs_previous_period_bigquery_return} is not null {% else %} 1=1 {% endif %} ;;

  join: products {
    type: left_outer
    view_label: "products"
    relationship: many_to_one
    sql_on: ${returns.product_key}=${products.product_key} ;;
  }
  join: product_subcategory {
    type: left_outer
    view_label: "product_subcategory"
    relationship: many_to_one
    sql_on: ${products.product_subcategory_key} = ${product_subcategory.product_subcategory_key} ;;
  }
  join: product_category {
    type: left_outer
    view_label: "product_category"
    relationship: many_to_one
    sql_on: ${product_subcategory.product_category_key}=${product_category.product_category_key} ;;
  }
  join: calendar {
    type: left_outer
    view_label: "Calendar"
    relationship: many_to_one
    sql_on: ${returns.return_date}=${calendar.date_date} ;;
    }
  join: territories2 {
    type: left_outer
    view_label: "territories"
    relationship: many_to_one
    sql_on: ${returns.territory_key} = ${territories2.sales_territory_key} ;;
  }
  join: parameters {}
  }
  explore: new_joiners_2 {}
  explore: new_customers_each_month {}
  explore: each_month_new_customers2 {}
  explore: distribution_customer {}
  explore: new_joiners3 {}
  explore: new_customer_each_month_trend {}
