import { DialogService } from './services/dialog.service';
import { ApiTokenService } from './services/apitoken.service';
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { LoginComponent } from './components/login/login.component';
import { HomeComponent } from './components/home/home.component';
import { RouterModule } from '@angular/router';
import { routes, appRoutingProviders } from './app.routes';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { ToolbarComponent } from './components/toolbar/toolbar.component';

import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatButtonToggleModule } from '@angular/material/button-toggle';
import { MatSortModule } from '@angular/material/sort';
import { MatTableModule } from '@angular/material/table';
import { MatPaginatorModule } from '@angular/material/paginator';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatDialogModule } from '@angular/material/dialog';
import { MatIconModule } from '@angular/material/icon';

import { ConfigService } from './services/config.service';
import { HttpClientModule } from '@angular/common/http';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { GenerateTokenComponent } from './components/dialogs/generate-token/generate-token.component';
import { DatePipe } from '@angular/common';
import { TmDatePipe } from './pipes/date.pipe';
import { SecurityService } from './services/security/security.service';

import { JwtModule } from '@auth0/angular-jwt';
import { ConfirmDisableComponent } from './components/dialogs/confirm-disable/confirm-disable.component';

export function tokenGetter() {
    return localStorage.getItem('tmToken');
}

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    HomeComponent,
    ToolbarComponent,
    GenerateTokenComponent,
    TmDatePipe,
    ConfirmDisableComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    RouterModule.forRoot(routes, { enableTracing: false }),
    BrowserAnimationsModule,
    FormsModule,
    ReactiveFormsModule,

    MatCardModule,
		MatFormFieldModule,
    MatInputModule,
		MatButtonModule,
    MatToolbarModule,
    MatButtonToggleModule,
    MatSortModule,
		MatTableModule,
		MatPaginatorModule,
		MatProgressSpinnerModule,
    MatDialogModule,
    MatIconModule,
    
    
    HttpClientModule,

    JwtModule.forRoot({
      config: {
        tokenGetter: tokenGetter,
        allowedDomains: ["localhost:44362"],
        disallowedRoutes: []
      }
    })
  ],
  providers: [
    ConfigService,
    ApiTokenService,
    DialogService,
    SecurityService,

    DatePipe,
    TmDatePipe
  ],
  exports: [
    TmDatePipe
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
