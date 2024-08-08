class Env {
  static bool isGalleryActive = false;

	//Utility functions to allow us to nest flutter projects within a parent application, without breaking fonts/image assets.
	//To facilitate this, the package value must be null when used in the primary project, but non-null when used from within the parent app.
	static String? getPackage(String value) => isGalleryActive? value : null;
	static String getBundle(String value) => "packages/$value";
}