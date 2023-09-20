view: customer_analysis_titles {

  dimension: Total_customers{
    type: string
    sql:"Total Customers";;
    html: <div style="background-color: #adc3db; padding: 10px; margin: 0;line-height: 1;">
    <h2> {{rendered_value}}</h2>
    </div>;;
  }
  dimension: Top_5_Customers_By_Sales{
    type: string
    sql:"Top 5 Customers By Sales";;
    html: <div style="background-color:#adc3db;">
          <h2 style="display: inline-block;vertical-align: middle;"> {{rendered_value}}</h2>
          <img src="https://img.freepik.com/free-icon/info-logo-circle_318-947.jpg?w=1380&t=st=1685014855~exp=1685015455~hmac=ab7ca0e5424d489b87f9027f4529ed7d8443474ae5f5e2bc4d4933c42cd53d89" height="20" width="30" style="display:inline-block;width: auto;height: 20px;border-radius: 20px;" title="Top N Customer Selection filter is applicable here" />
      </div>;;
}
  dimension: Total_Sales_by_Gender{
    type: string
    sql:"Total Sales by Gender";;
    html: <div style="background-color: #adc3db; padding: 10px; margin: 0;line-height: 1;">
          <h2> {{rendered_value}}</h2>
          </div>;;
  }
  dimension: Total_Sales_by_Education_Level{
    type: string
    sql:"Total Sales by Education Level";;
    html: <div style="background-color: #adc3db; padding: 10px; margin: 0;line-height: 1;">
          <h2> {{rendered_value}}</h2>
          </div>;;
  }

  dimension: Customer_Acquisition_Trend{
    type: string
    sql:"Customer Acquisition Trend";;
    html: <div style="background-color: #adc3db; padding: 10px; margin: 0;line-height: 1;">
          <h2> {{rendered_value}}</h2>
          </div>;;
  }
  dimension: Average_Order_Per_Customer_Trend{
    type: string
    sql:"Average Order Per Customer Trend";;
    html: <div style="background-color: #adc3db; padding: 10px; margin: 0;line-height: 1;">
          <h2> {{rendered_value}}</h2>
          </div>;;
  }
  dimension: Age_Wise_Total_Sales_Distribution{
    type: string
    sql:"Age Wise Total Sales Distribution";;
    html: <div style="background-color: #adc3db; padding: 10px; margin: 0;line-height: 1;">
          <h2> {{rendered_value}}</h2>
          </div>;;
  }
  dimension: Age_Wise_Avg_Order_Value_Distribution{
    type: string
    sql:"Age Wise Avg Order Value Distribution";;
    html: <div style="background-color: #adc3db; padding: 10px; margin: 0;line-height: 1;">
          <h2> {{rendered_value}}</h2>
          </div>;;
  }

  dimension: Income_Wise_Total_Sales_Distribution{
    type: string
    sql:"Income Wise Total Sales Distribution";;
    html: <div style="background-color: #adc3db; padding: 10px; margin: 0;line-height: 1;">
          <h2> {{rendered_value}}</h2>
          </div>;;
  }
  dimension: Income_Wise_Avg_Order_Value_Distribution{
    type: string
    sql:"Income Wise Avg Order Value Distribution";;
    html: <div style="background-color: #adc3db; padding: 10px; margin: 0;line-height: 1;">
          <h2> {{rendered_value}}</h2>
          </div>;;
  }



  dimension: Detail_Table{
    type: string
    sql:"Detail Table";;
    html: <div style="background-color:#adc3db;">
          <h2 style="display: inline-block;vertical-align: middle;"> {{rendered_value}}</h2>
          <img src="https://img.freepik.com/free-icon/info-logo-circle_318-947.jpg?w=1380&t=st=1685014855~exp=1685015455~hmac=ab7ca0e5424d489b87f9027f4529ed7d8443474ae5f5e2bc4d4933c42cd53d89" height="20" width="30" style="display:inline-block;width: auto;height: 20px;border-radius: 20px;" title="By clicking on '...', you can drill down" />
      </div>;;

  }






}
