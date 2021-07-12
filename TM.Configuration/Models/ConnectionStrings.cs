namespace TM.Configuration.Models
{
	/// <summary>
	/// The database connection strings.
	/// </summary>
	public class ConnectionStrings
	{
		/// <summary>
		/// Database read/write operation connection string.
		/// </summary>
		public string Command { get; set; }

		/// <summary>
		/// Database read operation connection string.
		/// </summary>
		public string Query { get; set; }
	}
}
