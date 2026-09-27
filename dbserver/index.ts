import { Database } from "bun:sqlite";
import { randomInt } from "node:crypto";

const db = new Database("../db1.sqlite");

interface Order {
  id: number;
  symbol: string;
  sl: number;
  tp: number;
  entry: number;
  safeEntry: number
  trig: number;
  mode: number;
  date: number;
}


class OrderImp implements Order {
  id = 0;
  symbol = "";
  sl = 0;
  tp = 0;
  entry = 0;
  safeEntry = 0;
  trig = 0;
  mode = 0;
  date = 0;
}

// CREATING TABLE
const t_SC_ORDERS = db.query(`create table if not exists SC_ORDERS(
          id number,
          symbol string,
          sl number,
          tp number,
          entry number,
          safeEntry number,
          trig number,
          mode number,
          date numnber
        );`);
t_SC_ORDERS.run();


const t_TEST_ORDERS = db.query(`create table if not exists TEST_ORDERS(
          id number,
          symbol string,
          sl number,
          tp number,
          entry number,
          safeEntry number,
          trig number,
          mode number,
          date number
        );`);
t_TEST_ORDERS.run();



// DUMBY DATA
const runOrderTest = () => {
  let testOrder = new OrderImp
  const keys: (keyof Order)[] = ["id", "symbol", "sl", "tp", "entry", "trig", "mode"];
  keys.forEach((key) => {
    if (key === "symbol") {
      testOrder[key] = "AUDJPY";
    } else {
      testOrder[key] = randomInt(3);
    }
  });

  testOrder.date = Date.now();

  console.log(testOrder);

  const query = db.query(`insert into TEST_ORDERS (
  id,symbol,sl,tp,entry,safeEntry,trig,mode,date) values(
    :id,:symbol,:sl,:tp,:entry,:safeEntry,:trig,:mode,:date);`);
  // you can run the spread as long as your order matches the order
  // of the sql query
  console.log(query.run(...Object.values(testOrder)));
}



const insertOrder = (o: Order) => {

  const query = db.query(`insert into OPEN_ORDERS (
  id,symbol,sl,tp,entry,safeEntry,trig,mode,date) values(
    ?1,?2,?3,?4,?5,?6,?7,?8,?9);`
  );

  Object.entries(o).forEach(([key, value]) => {
    if (typeof value === "number") {
      o[key] = Number(value.toFixed(5))
    }
  })

  o.date = Date.now()

  const runQuery = query.run(...Object.values(o));
  console.log(o)
  if (runQuery.changes === 1) {
    console.log("order added successfully")
  }
}
const server = Bun.serve({
  hostname: "127.0.0.1",
  port: 3030,
  routes: {
    "/test": {
      GET: req => {
        runOrderTest();
        console.log("testing add");
        return new Response("TESTED");
      },
      POST: async req => {
        const body = await req.json() as Order;
        insertOrder(body);
        return Response.json("GOT IT");
      },
    }
  },
  fetch(request) {
    return new Response("Welcome to Bun!");
  },
});

console.log("READY TO TAKE IT")


