using System;
using System.Collections.Generic;
using System.Text;

namespace TM.Models
{
	/// <summary>
	/// The Api token search result.
	/// </summary>
	public class ApiTokenSearchResult
	{
		public ApiTokenSearchResult()
		{
			this.TokenList = new List<ApiToken>();
		}
	
		/// <summary>
		/// The paged API token list.
		/// </summary>
		public IEnumerable<ApiToken> TokenList { get; set; }

		/// <summary>
		/// Total records in the search.
		/// </summary>
		public int TotalRecords { get; set; }
	}
}
