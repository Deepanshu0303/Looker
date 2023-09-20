view: parameters {

  parameter: select_timeframe {
    label: "Select Timeframe"
    type: unquoted
    default_value: "month"
    allowed_value: {
      value: "year"
      label: "Years"
    }
    allowed_value: {
      value: "quarter"
      label: "Quarters"
    }
    allowed_value: {
      value: "month"
      label: "Months"
    }
    allowed_value: {
      value: "week"
      label: "Weeks"
    }
   allowed_value: {
      value: "day"
      label: "Days"
    }
  }

  dimension: temp {
    hidden: yes
    type: string
    sql: {% if select_timeframe._parameter_value == 'year' %}
              "Months of"
         {% elsif select_timeframe._parameter_value == 'quarter' %}
              "Month of"
         {% elsif select_timeframe._parameter_value == 'month' %}
               "Days of"

         {% elsif select_timeframe._parameter_value == 'week' %}
               "Days of"

        {% elsif select_timeframe._parameter_value == 'day' %}
              "Hours of"
        {% endif %};;

  }


  parameter: select_reference_date {
    type: date
    convert_tz: no
  }
  #parameter: apply_to_date_filter {
   # type: yesno
    #default_value: "false"
  #}
  parameter: apply_to_date_filter {
    type: yesno
    default_value: "false"
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



}
