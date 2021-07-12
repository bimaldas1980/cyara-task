using Microsoft.Extensions.Options;

namespace TM.Configuration
{
	public class TmConfiguration : ITmConfiguration
	{
		public Models.ConnectionStrings ConnectionStrings { get; }
		public Models.SecuritySettings SecuritySettings { get; }
		public Models.ApplicationSettings ApplicationSettings { get; }

		public TmConfiguration(
			IOptionsSnapshot<Models.ConnectionStrings> connectionStrings,
			IOptionsSnapshot<Models.SecuritySettings> securittyStrings,
			IOptionsSnapshot<Models.ApplicationSettings> applicationSettings)
		{
			this.ConnectionStrings = connectionStrings.Value;
			this.SecuritySettings = securittyStrings.Value;
			this.ApplicationSettings = applicationSettings.Value;
		}
	}
}
