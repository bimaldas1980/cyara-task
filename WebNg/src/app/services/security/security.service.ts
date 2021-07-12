import { IAuthUser } from './../../models/auth-user.model';
import { IAuthModel } from './../../models/auth.model';
import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { ConfigService } from "../config.service";
import { JwtHelperService } from '@auth0/angular-jwt';
import { BehaviorSubject } from 'rxjs';

@Injectable()
export class SecurityService {

    constructor(
        private http: HttpClient,
        private config: ConfigService,
        private jwtHelper: JwtHelperService) {
        }

     jwtToken = 'tmToken';   

     authenticate(username: string, password: string) {
             const authModel: IAuthModel = {
                username: username,
                password: password
             };

             const url = `${this.config.getApiRootPath()}auth/login`; 
             return this.http.post<boolean>(url, authModel);
     }   

     setToken(res: any) {
        localStorage.setItem(this.jwtToken, res.token);
     }

     resetToken() {
         localStorage.removeItem(this.jwtToken);    
     }

     getToken() {
        return localStorage.getItem(this.jwtToken);
     }

     isAuthenticated() {
        const token = this.getToken();

        if (token && !this.jwtHelper.isTokenExpired(token)) {
                return true;
        }

        return false;
     }

     getAuthUserName() {
            const token = this.getToken();
            const claims = this.jwtHelper.decodeToken();
            return `${claims.givenname} ${claims.familyname}`; 
     }
}