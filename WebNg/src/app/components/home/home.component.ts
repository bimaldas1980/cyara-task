import { DialogService } from './../../services/dialog.service';
import { IApiTokenSearchResult } from './../../models/apitoken-search-result.model';
import { IApiToken } from './../../models/apitoken.model';
import { ApiTokenService } from './../../services/apitoken.service';
import { Component } from '@angular/core';
import { debounceTime, filter, map, switchMap } from 'rxjs/operators';
import { debounce, noop as _noop } from 'lodash';



@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent {

  displayedColumns = ['token', 'startDate', 'endDate', 'createdBy', 'createdAt','modifiedBy', 'modifiedAt', 'id'];
  
  totalRecords: number = 0;
  dataSource: IApiToken[] = [];
  pageNumber = 1;

  searchFilter = '';

  constructor(
      private apiTokenService: ApiTokenService,
      private dialogService: DialogService) {
          this.searchTokens(this.searchFilter, this.pageNumber);
      }

  onTableScroll(e: any) {
      if (this.dataSource && this.dataSource.length === this.totalRecords) {
          return;
      }

      const tableViewHeight = e.target.offsetHeight // viewport: ~500px
      const tableScrollHeight = e.target.scrollHeight // length of all table
      const scrollLocation = e.target.scrollTop; // how far user scrolled
      
      // If the user has scrolled within 200px of the bottom, add more data
      const buffer = 10;
      const limit = tableScrollHeight - tableViewHeight - buffer;  
      
      if (scrollLocation > limit) {
        this.searchTokens(this.searchFilter, this.pageNumber);
      }
      
  }

  filterTokens() {
    this.dataSource = [];
    this.pageNumber = 1;
    this.searchTokens(this.searchFilter, this.pageNumber);
  }

  searchTokens(search: string, pageNumner: number) {

    this.apiTokenService.searchTokens(search, this.pageNumber)
    .pipe(
      debounceTime(200),
      map ((result: IApiTokenSearchResult) => {
        this.dataSource = this.dataSource.concat(result.tokenList);
        this.totalRecords = result.totalRecords;
        this.pageNumber += 1;
      })
    )
    .subscribe();
  }

  generateToken() {

    this.apiTokenService.generateToken()
    .pipe(
        switchMap(item => this.dialogService.generateTokenDialog(item.token))
    )
    .subscribe();
 }
 
 disable(id: number, token: string) {
    this.dialogService.diableTokenConfirmDialog(id, token)
    .pipe(
      filter(result => !!result),
      switchMap(() => this.apiTokenService.disableToken(id))
    )
    .subscribe(() => {
      this.filterTokens();
    });
 }
}
