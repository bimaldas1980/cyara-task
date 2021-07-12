using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using TM.Models;

namespace TM.Data.Interface
{
	/// <summary>
	/// The Token services.
	/// </summary>
	public interface IApiTokenService
	{
		/// <summary>
		/// API to generate a new token.
		/// </summary>
		/// <returns></returns>
		Task<ApiToken> GenerateTokenAsync();

		/// <summary>
		/// API to enable a token.
		/// </summary>
		/// <param name="tokenId">The unique identifier of a token.</param>
		/// <returns></returns>
		Task EnableTokenAsync(int tokenId);

		/// <summary>
		/// API to disable a token.
		/// </summary>
		/// <param name="tokenId">The unique identifier of a token.</param>
		/// <returns></returns>
		Task DisableTokenAsync(int tokenId);

		/// <summary>
		/// API to search a token.
		/// </summary>
		/// <param name="search">The search string.</param>
		/// <param name="pageNumber">The page number.</param>
		/// <returns>A token search result object with paged search result and total number of records.</returns>
		Task<ApiTokenSearchResult> SearchTokensAsync(string search, int? pageNumber);

		/// <summary>
		/// API to validate a token.
		/// </summary>
		/// <param name="token">The token.</param>
		/// <param name="asOfDate">The as of date.</param>
		/// <returns></returns>
		Task<bool> ValidateAsync(string token, DateTime? asOfDate = null);
	}
}
