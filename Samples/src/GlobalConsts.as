package
{
	public class GlobalConsts
	{
		// if you use native app (AIR) cache can be saved into a file, if not (Browser) cache will not be used
		public static const NATIVE_APP  	: Boolean = true;	
		
		// cache must use (AIR File API) so only native apps can save cache
		public static const USE_CACHE 		: Boolean = false && NATIVE_APP;
		
		// make sure that you change the cache version if you changed your loaded assets
		public static const CACHE_VERSION	: String = "1";	
	}
}