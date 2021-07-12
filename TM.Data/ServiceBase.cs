using System.Data;
using System.Data.SqlClient;
using TM.Configuration;

namespace TM.Data
{
	public class ServiceBase
	{
		protected const CommandType CtProc = CommandType.StoredProcedure;

        protected ITmConfiguration Configuration { get; private set; }

        public ServiceBase(ITmConfiguration configurationService)
        {
            Configuration = configurationService;
        }

        /// <summary>
        /// Gets an IDbConnection Dapper readonly access.
        /// </summary>
        /// <returns></returns>
        protected IDbConnection GetReadOnlyDbConnection()
        {
            var connString = Configuration.ConnectionStrings.Query;
            var conn = new SqlConnection(connString);
            return conn;
        }

        /// <summary>
        /// Gets an IDbConnection Dapper read/write access.
        /// </summary>
        /// <returns></returns>
        protected IDbConnection GetReadWriteDbConnection()
        {
            var connString = Configuration.ConnectionStrings.Command;
            var conn = new SqlConnection(connString);
            return conn;
        }
    }
}
