using System;
using System.Collections.Generic;
using System.Text;

namespace TM.Configuration.Models
{
	/// <summary>
	/// The security setting configurations.
	/// </summary>
	public class SecuritySettings
	{
		/// <summary>
		/// Life time of a JWT token.
		/// </summary>
		public int JwtLifetime { get; set; }
		public string JwtSecureKey { get; set; }
		public string JwtIssuer { get; set; }
		public string JwtAudience { get; set; }
	}
}
