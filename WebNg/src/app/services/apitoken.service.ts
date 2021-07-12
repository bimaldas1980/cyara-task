import { ConfigService } from './config.service';
import { HttpClient, HttpHeaders, HttpParams } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { IApiToken } from '../models/apitoken.model';
import { IApiTokenSearchResult } from '../models/apitoken-search-result.model';

/**
 * Consumes end point to Token services.
 */
@Injectable()
export class ApiTokenService {
    constructor(
        private http: HttpClient,
        private config: ConfigService) {
    }

    /**
     * Searches API tokens
     * @param search The search param
     * @param pageNumber The page number
     * @returns A list of API token models.
     */
    searchTokens(search: string, pageNumber: number) {
        const url = `${this.config.getApiRootPath()}token/search`; 

        if (!pageNumber) pageNumber = 1;

        const params = new HttpParams()
            .set('search', search)
            .set('pageNumber', pageNumber);

        return this.http.get<IApiTokenSearchResult>(url, { params });
    }

    /**
     * Generate new API token.
     * @returns Newly generated token model.
     */
    generateToken() {
        const url = `${this.config.getApiRootPath()}token/generate`; 
       
        return this.http.post<IApiToken>(url, null);
    }

    /**
     * Enable a token.
     */
     disableToken(id: number) {
        const url = `${this.config.getApiRootPath()}token/disable`; 
       
        return this.http.post<IApiToken>(url, id);
    }

}