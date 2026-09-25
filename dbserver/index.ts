import { Database } from "bun:sqlite";
import { randomInt } from "node:crypto";

const db = new Database("../db1.sqlite");

class Order {
  id!: number;
  symbol!: string;
  sl!: number;
  tp!: number;
  entry!: number;
  safeEntry!: number
  trig!: number;
  size!: number;
  mode!: number;
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
          mode number
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
          mode number
        );`);
t_TEST_ORDERS.run();



// DUMBY DATA
const testOrder = new Order;
const runOrderTest = () => {
  const keys: (keyof Order)[] = ["id", "symbol", "sl", "tp", "entry", "trig", "mode"];
  keys.forEach((key) => {
    if (key === "symbol") {
      testOrder[key] = "AUDJPY";
    } else {
      testOrder[key] = randomInt(3);
    }
  });


  console.log(testOrder);
}



const insertOrder = (o: Order) => {

  const queryInsertOrder = db.query(`insert into OPEN_ORDERS (
  id,symbol,sl,tp,entry,safeEntry,trig,mode) values(
    ?1,?2,?3,?4,?5,?6,?7,?8);`
  );

  Object.entries(o).forEach(([key, value]) => {
    if (typeof value === "number") {
      o[key] = Number(value.toFixed(5))
    }
  })

  const runQuery = queryInsertOrder.run(
    o.id,
    o.symbol,
    o.sl,
    o.tp,
    o.entry,
    o.safeEntry,
    o.trig,
    o.mode,
  );
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


