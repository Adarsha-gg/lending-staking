"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g = Object.create((typeof Iterator === "function" ? Iterator : Object).prototype);
    return g.next = verb(0), g["throw"] = verb(1), g["return"] = verb(2), typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (g && (g = 0, op[0] && (_ = 0)), _) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
Object.defineProperty(exports, "__esModule", { value: true });
var viem_1 = require("viem");
require("viem/window");
var dotenv_1 = require("dotenv");
var YieldFarming_json_1 = require("../../out/lending.sol/YieldFarming.json");
dotenv_1.default.config();
var contract_abi = YieldFarming_json_1.default["abi"];
var contract;
var WalletClient;
function connect() {
    return __awaiter(this, void 0, void 0, function () {
        return __generator(this, function (_a) {
            // WalletClient = createWalletClient({
            //     chain: sepolia,
            //     transport: custom(window.ethereum!)
            //   });
            // const address = WalletClient.requestAddresses();
            // console.log(address);
            // contract = getContract({
            //     address: '0x30f6b15c7f964237b41f066b0a5cb5117d4fad9d',
            //     abi: contract_abi,
            //     client: WalletClient, // or walletClient,
            // });  
            console.log("Clcikerkerkekrer");
            return [2 /*return*/];
        });
    });
}
function stake() {
    return __awaiter(this, void 0, void 0, function () {
        var stakeAmount, amount;
        var _a;
        return __generator(this, function (_b) {
            switch (_b.label) {
                case 0:
                    stakeAmount = (_a = document.getElementById("stakeAmount")) === null || _a === void 0 ? void 0 : _a.value;
                    amount = (0, viem_1.parseEther)(stakeAmount);
                    return [4 /*yield*/, contract.write.stake([amount])];
                case 1:
                    _b.sent();
                    return [2 /*return*/];
            }
        });
    });
}
function claim() {
    return __awaiter(this, void 0, void 0, function () {
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, contract.write.claimReward()];
                case 1:
                    _a.sent();
                    return [2 /*return*/];
            }
        });
    });
}
function withdraw() {
    return __awaiter(this, void 0, void 0, function () {
        var withdrawAmount, amount;
        var _a;
        return __generator(this, function (_b) {
            switch (_b.label) {
                case 0:
                    withdrawAmount = (_a = document.getElementById("withdrawAmount")) === null || _a === void 0 ? void 0 : _a.value;
                    amount = (0, viem_1.parseEther)(withdrawAmount);
                    return [4 /*yield*/, contract.write.withdraw([amount])];
                case 1:
                    _b.sent();
                    return [2 /*return*/];
            }
        });
    });
}
document.addEventListener("DOMContentLoaded", function () {
    var connectButton = document.getElementById("connectButton");
    var stakeButton = document.getElementById("stakeButton");
    var withdrawButton = document.getElementById("withdrawButton");
    var claimButton = document.getElementById("claimButton");
    connectButton === null || connectButton === void 0 ? void 0 : connectButton.addEventListener("click", connect);
    stakeButton === null || stakeButton === void 0 ? void 0 : stakeButton.addEventListener("click", stake);
    withdrawButton === null || withdrawButton === void 0 ? void 0 : withdrawButton.addEventListener("click", withdraw);
    claimButton === null || claimButton === void 0 ? void 0 : claimButton.addEventListener("click", claim);
});
