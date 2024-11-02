import { privateKeyToAccount } from "viem/accounts"
import { createPublicClient, http, formatEther, Hex } from "viem";
import {sepolia} from "viem/chains"
import dotenv from "dotenv";

dotenv.config();

const privateKey = process.env.PRIVATE_KEY;

// Assert that privateKey is in the correct format
const account = privateKeyToAccount(privateKey as Hex);