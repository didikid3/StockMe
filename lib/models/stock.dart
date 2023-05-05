class Stock{
  String symbol;
  String? company;
  double? price;
  String? change;

  Stock(this.symbol){
    company = "";
    change = "0";
    price = 0;
  }

  void setName(String x){
    company = x;
  }
  String? getComp(){
    return company;
  }

  void setPrice(double x){
    price = x;
  }

  void setChange(String x){
    change = x;
  }
  String getChange(){
    return change.toString();
    }
  }

