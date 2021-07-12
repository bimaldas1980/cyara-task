using System;
using TM.Models;
using TM.Configuration;
using TM.Data.Interface;
using System.Threading.Tasks;
using Dapper;

namespace TM.Data.Services
{
	/// <inheritdoc />
	public class UserService : ServiceBase, IUserService
	{
		/// <inheritdoc />
		public UserService(ITmConfiguration configurationService)
			: base(configurationService)
		{

		}

		/// <inheritdoc />
		public async Task<TmUser> AuthenticateAsync(string username, string password)
		{
			var parameters = new
			{
				Username = username,
				Password = password
			};

			using (var conn = GetReadWriteDbConnection())
			{
				return await conn.QueryFirstAsync<TmUser>("sec.proc_AuthenticateUser", param: parameters, commandType: System.Data.CommandType.StoredProcedure);
			}
		}

		/// <inheritdoc />
		public async Task<TmUser> GetUserByUsernameAsync(string username)
		{
			var parameters = new
			{
				Username = username
			};

			using (var conn = GetReadOnlyDbConnection())
			{
				return await conn.QueryFirstAsync<TmUser>("sec.proc_GetUserByUsername", param: parameters, commandType: System.Data.CommandType.StoredProcedure);
			}
		}
	}
}
