namespace TM.Configuration
{
	public interface ITmConfiguration
	{
		Models.ConnectionStrings ConnectionStrings { get; }
		Models.SecuritySettings SecuritySettings { get; }
		Models.ApplicationSettings ApplicationSettings { get; }
	}
}
