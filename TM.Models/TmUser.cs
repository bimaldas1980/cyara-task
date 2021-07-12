namespace TM.Models
{
	/// <summary>
	/// The user model.
	/// </summary>
	public class TmUser
	{
		/// <summary>
		/// The unique identifier
		/// </summary>
		public int Id { get; set; }

		/// <summary>
		/// The username.
		/// </summary>
		public string Username { get; set; }

		/// <summary>
		/// The given name.
		/// </summary>
		public string GivenNames { get; set; }

		/// <summary>
		/// The family name.
		/// </summary>
		public string FamilyName { get; set; }
	}
}
