using System;
using System.Threading.Tasks;
using TM.Data.Interface;
using TM.Configuration;
using TM.Models;
using Dapper;
using System.Collections.Generic;

namespace TM.Data.Services
{
	/// <inheritdoc />
	public class ApiTokenService : ServiceBase, IApiTokenService
	{
		ITmConfiguration TmConfiguration { get; }
		/// <inheritdoc />
		public ApiTokenService(ITmConfiguration configurationService)
			: base(configurationService)
		{
			TmConfiguration = configurationService;
		}

		/// <inheritdoc />
		public async Task DisableTokenAsync(int tokenId)
		{
			var parameters = new
			{
				TokenId = tokenId,
				ModifiedByUserId = 1
			};

			using (var conn = GetReadWriteDbConnection())
			{
				await conn.ExecuteAsync("dbo.proc_disableToken", param: parameters, commandType: System.Data.CommandType.StoredProcedure);
			}
		}

		/// <inheritdoc />
		public async Task EnableTokenAsync(int tokenId)
		{
			var parameters = new
			{
				TokenId = tokenId,
				ModifiedByUserId = 1
			};

			using (var conn = GetReadWriteDbConnection())
			{
				await conn.ExecuteAsync("dbo.proc_enableToken", param: parameters, commandType: System.Data.CommandType.StoredProcedure);
			}
		}

		/// <inheritdoc />
		public async Task<ApiToken> GenerateTokenAsync()
		{
			var parameters = new
			{
				CreatedByUserId = 1
			};

			using (var conn = GetReadWriteDbConnection())
			{
				return await conn.QuerySingleAsync<ApiToken>("dbo.proc_GenerateToken", param: parameters, commandType: System.Data.CommandType.StoredProcedure);
			}
		}

		/// <inheritdoc />
		public async Task<ApiTokenSearchResult> SearchTokensAsync(string search, int? pageNumber)
		{
			var parameters = new
			{
				Search = string.IsNullOrWhiteSpace(search) ? null : search,
				PageNumber = pageNumber.HasValue ? pageNumber.Value : 1,
				PageSize = TmConfiguration.ApplicationSettings.HomePageSize
			};

			var result = new ApiTokenSearchResult();

			using (var conn = GetReadOnlyDbConnection())
			{
				var reader = await conn.QueryMultipleAsync("dbo.proc_searchTokens", param: parameters, commandType: System.Data.CommandType.StoredProcedure);
				result.TokenList = await reader.ReadAsync<ApiToken>();
				result.TotalRecords = await reader.ReadSingleAsync<int>();
				return result;
			}
		}

		/// <inheritdoc />
		public async Task<bool> ValidateAsync(string token, DateTime? asOfDate = null)
		{
			var parameters = new
			{
				Token = token,
				AsOfDate = asOfDate.HasValue ? asOfDate.Value.Date : DateTime.Now.Date
			};

			using (var conn = GetReadOnlyDbConnection())
			{
				return await conn.QuerySingleAsync<bool>("dbo.proc_ValidateToken", param: parameters, commandType: System.Data.CommandType.StoredProcedure);
			}
		}
	}
}
