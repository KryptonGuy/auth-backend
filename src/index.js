import express from "express";
import bodyParser from "body-parser";
import session from "express-session";
import cors from "cors";
import flash from "connect-flash";

import { connect } from "./config/database.js";
import config from "./config/serverConfig.js";

import apiRoutes from "./routes/index.js";

import passport from "passport";
import { passportAuth } from "./config/jwt-middleware.js";
import "./config/google-authenticate.js";
import "./config/github-authenticate.js";

const app = express();
// Set up session middleware with a secret key
app.use(session({ secret: "cats", resave: false, saveUninitialized: true }));

app.use(passport.initialize());
app.use(passport.session());
app.use(flash());

passportAuth(passport);
app.use(
  cors({
    origin: config.baseUrl ?? "*",
    credentials: true,
  })
);

app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*');  // Access Multiple domains via ','
  res.setHeader('Access-Control-Allow-Methods', 'GET POST PUT PATCH DELETE');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  next();
});

const startServer = async () => {
  app.use(bodyParser.json());
  app.use(bodyParser.urlencoded({ extended: true }));

  app.use("/api", apiRoutes);

  app.get("/", (req, res) => {
    
    // Render a link to authenticate with Google
    res.send(
      '<div> <a href="/api/v1/auth/google">Authenticate with Google</a><a href="/api/v1/auth/github">Authenticate with Github</a></div>'
    );
  });

  app.listen(config.PORT, async () => {
    console.log(`server started at port ${config.PORT}`);
    await connect();
    console.log("Mongo db connected");
  });
};
startServer();
