//+------------------------------------------------------------------+
//|                                                    SC_Bridge.mq5 |
//|                                  Copyright 2026, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

int db;

struct Order{
   int id;
   string sybol;
   float sl;
   float tp;
   float entry;
   float safeEntry;
   float trig;
   int mode;
   long date;
};

int OnInit()
{
   //--- create timer
   EventSetTimer(10);

   string dbName = "DB_sc-bridge.sqlite";
   db = DatabaseOpen(dbName, DATABASE_OPEN_READWRITE);
   if(db==INVALID_HANDLE)
   {
      Print("DB: ", dbName, " open failed with code ", GetLastError());
      return("failed to open db");
   }


return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   //--- destroy timer
   EventKillTimer();
   DatabaseClose(db);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   //---
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
   datetime t1 = iTime(NULL, 0, 0);
   datetime t2 = iTime(NULL, 0, 20);
   double p1 = iClose(NULL, 0, 0);
   double p2 = iClose(NULL, 0, 20);

   Comment("i love my bbc(big booty caucasian)");

   ObjectCreate(
   0,
   "test recky",
   OBJ_RECTANGLE,
   0,
   t1,
   p1,
   t2,
   p2
   );


   Print("Hello");
   //DatabasePrint(db, "SELECT * from TEST_ORDERS", 0);
   //---

}
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()
{
   //---

}
//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
const MqlTradeRequest& request,
const MqlTradeResult& result)
{
   //---

}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int32_t id,
const long &lparam,
const double &dparam,
const string &sparam)
{
   //---

}
//+------------------------------------------------------------------+
