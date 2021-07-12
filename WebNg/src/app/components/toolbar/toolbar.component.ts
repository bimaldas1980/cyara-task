import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { SecurityService } from 'src/app/services/security/security.service';

@Component({
  selector: 'app-toolbar',
  templateUrl: './toolbar.component.html',
  styleUrls: ['./toolbar.component.scss']
})
export class ToolbarComponent implements OnInit {

  constructor(private securityService: SecurityService,
              private router: Router) { 
                
  }

  isAuthenticated() {
    return this.securityService.isAuthenticated();
  }

  loggedInUsername() {
    return this.securityService.getAuthUserName();
  }

  ngOnInit(): void {
  }

  logout() {
    this.securityService.resetToken();
    this.router.navigateByUrl('/login');
  }
}
