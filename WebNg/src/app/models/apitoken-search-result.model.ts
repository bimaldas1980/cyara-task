import { IApiToken } from "./apitoken.model";

export interface IApiTokenSearchResult {
    tokenList: IApiToken[];
    totalRecords: number;
}