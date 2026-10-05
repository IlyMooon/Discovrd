import os

# Liste complète avec chemin relatif exact par rapport à la racine du projet
sources = [
    ("DiscovrdApp.swift", "Discovrd/Sources/App/DiscovrdApp.swift"),
    ("TrackItem.swift", "Discovrd/Sources/Models/TrackItem.swift"),
    ("SwipeRecord.swift", "Discovrd/Sources/Models/SwipeRecord.swift"),
    ("CachedTasteProfile.swift", "Discovrd/Sources/Models/CachedTasteProfile.swift"),
    ("TasteProfile.swift", "Discovrd/Sources/Models/TasteProfile.swift"),
    ("DeckAlgorithm.swift", "Discovrd/Sources/Models/DeckAlgorithm.swift"),
    ("AppSettings.swift", "Discovrd/Sources/Models/AppSettings.swift"),
    ("ServiceProtocols.swift", "Discovrd/Sources/Services/ServiceProtocols.swift"),
    ("SwiftDataSwipeStore.swift", "Discovrd/Sources/Services/SwiftDataSwipeStore.swift"),
    ("TasteProfileService.swift", "Discovrd/Sources/Services/TasteProfileService.swift"),
    ("MusicAPINetworkClient.swift", "Discovrd/Sources/Services/MusicAPINetworkClient.swift"),
    ("AppleMusicService.swift", "Discovrd/Sources/Services/AppleMusicService.swift"),
    ("MockMusicService.swift", "Discovrd/Sources/Services/MockMusicService.swift"),
    ("MockSwipeStore.swift", "Discovrd/Sources/Services/MockSwipeStore.swift"),
    ("AudioPreviewPlayer.swift", "Discovrd/Sources/Services/AudioPreviewPlayer.swift"),
    ("AmbientArtworkBackground.swift", "Discovrd/Sources/Views/Components/AmbientArtworkBackground.swift"),
    ("TrackCardView.swift", "Discovrd/Sources/Views/Components/TrackCardView.swift"),
    ("ActionButtonsBar.swift", "Discovrd/Sources/Views/Components/ActionButtonsBar.swift"),
    ("SwipeStampView.swift", "Discovrd/Sources/Views/Components/SwipeStampView.swift"),
    ("SwipeDeckView.swift", "Discovrd/Sources/Views/Components/SwipeDeckView.swift"),
    ("EmptyDeckView.swift", "Discovrd/Sources/Views/Components/EmptyDeckView.swift"),
    ("ErrorView.swift", "Discovrd/Sources/Views/Components/ErrorView.swift"),
    ("DiscoverViewModel.swift", "Discovrd/Sources/Views/Discover/DiscoverViewModel.swift"),
    ("DiscoverView.swift", "Discovrd/Sources/Views/Discover/DiscoverView.swift"),
    ("MyArtistsViewModel.swift", "Discovrd/Sources/Views/MyArtists/MyArtistsViewModel.swift"),
    ("MyArtistsView.swift", "Discovrd/Sources/Views/MyArtists/MyArtistsView.swift"),
    ("SettingsView.swift", "Discovrd/Sources/Views/Settings/SettingsView.swift"),
    ("OnboardingView.swift", "Discovrd/Sources/Views/Onboarding/OnboardingView.swift"),
    ("AuthorizationPromptView.swift", "Discovrd/Sources/Views/Onboarding/AuthorizationPromptView.swift"),
    ("MainTabView.swift", "Discovrd/Sources/Views/MainTabView.swift"),
    ("DiscovrdPreviews.swift", "Discovrd/Sources/Views/DiscovrdPreviews.swift"),
]

def make_id(prefix, idx):
    return f"{prefix}{idx:022X}"

pbx = """// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {

/* Begin PBXBuildFile section */
"""

for i, (name, path) in enumerate(sources):
    bid = make_id("A1", i + 1)
    fid = make_id("F1", i + 1)
    pbx += f"\t\t{bid} /* {name} in Sources */ = {{isa = PBXBuildFile; fileRef = {fid} /* {name} */; }};\n"

pbx += f"\t\tB100000000000000000001 /* Assets.xcassets in Resources */ = {{isa = PBXBuildFile; fileRef = R100000000000000000001 /* Assets.xcassets */; }};\n"
pbx += f"\t\tB100000000000000000002 /* PrivacyInfo.xcprivacy in Resources */ = {{isa = PBXBuildFile; fileRef = R100000000000000000002 /* PrivacyInfo.xcprivacy */; }};\n"

pbx += """/* End PBXBuildFile section */

/* Begin PBXFileReference section */
\t\t000000000000000000000008 /* Discovrd.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = Discovrd.app; sourceTree = BUILT_PRODUCTS_DIR; };
"""

for i, (name, path) in enumerate(sources):
    fid = make_id("F1", i + 1)
    pbx += f"\t\t{fid} /* {name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = \"{path}\"; sourceTree = \"<group>\"; }};\n"

pbx += f"\t\tR100000000000000000001 /* Assets.xcassets */ = {{isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = \"Discovrd/Resources/Assets.xcassets\"; sourceTree = \"<group>\"; }};\n"
pbx += f"\t\tR100000000000000000002 /* PrivacyInfo.xcprivacy */ = {{isa = PBXFileReference; lastKnownFileType = text.xml; path = \"Discovrd/Resources/PrivacyInfo.xcprivacy\"; sourceTree = \"<group>\"; }};\n"
pbx += f"\t\tR100000000000000000003 /* Info.plist */ = {{isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = \"Discovrd/Resources/Info.plist\"; sourceTree = \"<group>\"; }};\n"

pbx += """/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
\t\t000000000000000000000005 /* Frameworks */ = {
\t\t\tisa = PBXFrameworksBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
\t\t000000000000000000000003 = {
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t000000000000000000000010 /* Discovrd */,
\t\t\t\t000000000000000000000007 /* Products */,
\t\t\t);
\t\t\tsourceTree = "<group>";
\t\t};
\t\t000000000000000000000007 /* Products */ = {
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t000000000000000000000008 /* Discovrd.app */,
\t\t\t);
\t\t\tname = Products;
\t\t\tsourceTree = "<group>";
\t\t};
\t\t000000000000000000000010 /* Discovrd */ = {
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
"""

for i, (name, path) in enumerate(sources):
    fid = make_id("F1", i + 1)
    pbx += f"\t\t\t\t{fid} /* {name} */,\n"

pbx += """\t\t\t\tR100000000000000000001 /* Assets.xcassets */,
\t\t\t\tR100000000000000000002 /* PrivacyInfo.xcprivacy */,
\t\t\t\tR100000000000000000003 /* Info.plist */,
\t\t\t);
\t\t\tsourceTree = "<group>";
\t\t};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
\t\t000000000000000000000002 /* Discovrd */ = {
\t\t\tisa = PBXNativeTarget;
\t\t\tbuildConfigurationList = 00000000000000000000000C /* Build configuration list for PBXNativeTarget "Discovrd" */;
\t\t\tbuildPhases = (
\t\t\t\t000000000000000000000004 /* Sources */,
\t\t\t\t000000000000000000000005 /* Frameworks */,
\t\t\t\t000000000000000000000006 /* Resources */,
\t\t\t);
\t\t\tbuildRules = (
\t\t\t);
\t\t\tdependencies = (
\t\t\t);
\t\t\tname = Discovrd;
\t\t\tproductName = Discovrd;
\t\t\tproductReference = 000000000000000000000008 /* Discovrd.app */;
\t\t\tproductType = "com.apple.product-type.application";
\t\t};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
\t\t000000000000000000000001 /* Project object */ = {
\t\t\tisa = PBXProject;
\t\t\tattributes = {
\t\t\t\tBuildIndependentTargetsInParallel = 1;
\t\t\t\tLastSwiftUpdateCheck = 2600;
\t\t\t\tLastUpgradeCheck = 2600;
\t\t\t\tTargetAttributes = {
\t\t\t\t\t000000000000000000000002 = {
\t\t\t\t\t\tCreatedOnToolsVersion = 26.0;
\t\t\t\t\t};
\t\t\t\t};
\t\t\t};
\t\t\tbuildConfigurationList = 000000000000000000000009 /* Build configuration list for PBXProject "Discovrd" */;
\t\t\tcompatibilityVersion = "Xcode 14.0";
\t\t\tdevelopmentRegion = fr;
\t\t\thasScannedForEncodings = 0;
\t\t\tknownRegions = (
\t\t\t\tfr,
\t\t\t\ten,
\t\t\t\tBase,
\t\t\t);
\t\t\tmainGroup = 000000000000000000000003;
\t\t\tproductRefGroup = 000000000000000000000007 /* Products */;
\t\t\tprojectDirPath = "";
\t\t\tprojectRoot = "";
\t\t\ttargets = (
\t\t\t\t000000000000000000000002 /* Discovrd */,
\t\t\t);
\t\t};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
\t\t000000000000000000000006 /* Resources */ = {
\t\t\tisa = PBXResourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t\tB100000000000000000001 /* Assets.xcassets in Resources */,
\t\t\t\tB100000000000000000002 /* PrivacyInfo.xcprivacy in Resources */,
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
\t\t000000000000000000000004 /* Sources */ = {
\t\t\tisa = PBXSourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
"""

for i, (name, path) in enumerate(sources):
    bid = make_id("A1", i + 1)
    pbx += f"\t\t\t\t{bid} /* {name} in Sources */,\n"

pbx += """\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
\t\t00000000000000000000000A /* Debug */ = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;
\t\t\t\tCLANG_ANALYZER_NONNULL = YES;
\t\t\t\tCLANG_ENABLE_MODULES = YES;
\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;
\t\t\t\tCOPY_PHASE_STRIP = NO;
\t\t\t\tDEBUG_INFORMATION_FORMAT = dwarf;
\t\t\t\tENABLE_PREVIEWS = NO;
\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;
\t\t\t\tENABLE_TESTABILITY = YES;
\t\t\t\tGCC_DYNAMIC_NO_PIC = NO;
\t\t\t\tGCC_OPTIMIZATION_LEVEL = 0;
\t\t\t\tGCC_PREPROCESSOR_DEFINITIONS = (
\t\t\t\t\t"DEBUG=1",
\t\t\t\t\t"$(inherited)",
\t\t\t\t);
\t\t\t\tGCC_WARN_64_TO_32_BIT_CONVERSION = YES;
\t\t\t\tGCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
\t\t\t\tGCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 26.0;
\t\t\t\tMTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
\t\t\t\tMTL_FAST_MATH = YES;
\t\t\t\tONLY_ACTIVE_ARCH = YES;
\t\t\t\tSDKROOT = iphoneos;
\t\t\t\tSWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-Onone";
\t\t\t\tSWIFT_STRICT_CONCURRENCY = complete;
\t\t\t\tSWIFT_VERSION = 6.0;
\t\t\t};
\t\t\tname = Debug;
\t\t};
\t\t00000000000000000000000B /* Release */ = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;
\t\t\t\tCLANG_ANALYZER_NONNULL = YES;
\t\t\t\tCLANG_ENABLE_MODULES = YES;
\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;
\t\t\t\tCOPY_PHASE_STRIP = NO;
\t\t\t\tDEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
\t\t\t\tENABLE_NS_ASSERTIONS = NO;
\t\t\t\tENABLE_PREVIEWS = NO;
\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;
\t\t\t\tGCC_NO_COMMON_BLOCKS = YES;
\t\t\t\tGCC_WARN_64_TO_32_BIT_CONVERSION = YES;
\t\t\t\tGCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 26.0;
\t\t\t\tMTL_ENABLE_DEBUG_INFO = NO;
\t\t\t\tMTL_FAST_MATH = YES;
\t\t\t\tSDKROOT = iphoneos;
\t\t\t\tSWIFT_COMPILATION_MODE = wholemodule;
\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-O";
\t\t\t\tSWIFT_STRICT_CONCURRENCY = complete;
\t\t\t\tSWIFT_VERSION = 6.0;
\t\t\t\tVALIDATE_PRODUCT = YES;
\t\t\t};
\t\t\tname = Release;
\t\t};
\t\t00000000000000000000000D /* Debug */ = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
\t\t\t\tASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
\t\t\t\tCODE_SIGN_IDENTITY = "-";
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tDEVELOPMENT_TEAM = "";
\t\t\t\tENABLE_PREVIEWS = NO;
\t\t\t\tGENERATE_INFOPLIST_FILE = NO;
\t\t\t\tINFOPLIST_FILE = Discovrd/Resources/Info.plist;
\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (
\t\t\t\t\t"$(inherited)",
\t\t\t\t\t"@executable_path/Frameworks",
\t\t\t\t);
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.Discovrd;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;
\t\t\t\tSWIFT_STRICT_CONCURRENCY = complete;
\t\t\t\tSWIFT_VERSION = 6.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = 1;
\t\t\t};
\t\t\tname = Debug;
\t\t};
\t\t00000000000000000000000E /* Release */ = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
\t\t\t\tASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
\t\t\t\tCODE_SIGN_IDENTITY = "-";
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tDEVELOPMENT_TEAM = "";
\t\t\t\tENABLE_PREVIEWS = NO;
\t\t\t\tGENERATE_INFOPLIST_FILE = NO;
\t\t\t\tINFOPLIST_FILE = Discovrd/Resources/Info.plist;
\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (
\t\t\t\t\t"$(inherited)",
\t\t\t\t\t"@executable_path/Frameworks",
\t\t\t\t);
\t\t\t\tMARKETING_VERSION = 1.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.example.Discovrd;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;
\t\t\t\tSWIFT_STRICT_CONCURRENCY = complete;
\t\t\t\tSWIFT_VERSION = 6.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = 1;
\t\t\t};
\t\t\tname = Release;
\t\t};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
\t\t000000000000000000000009 /* Build configuration list for PBXProject "Discovrd" */ = {
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t00000000000000000000000A /* Debug */,
\t\t\t\t00000000000000000000000B /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t};
\t\t00000000000000000000000C /* Build configuration list for PBXNativeTarget "Discovrd" */ = {
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t00000000000000000000000D /* Debug */,
\t\t\t\t00000000000000000000000E /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t};
/* End XCConfigurationList section */
	};
	rootObject = 000000000000000000000001 /* Project object */;
}
"""

with open("/Users/germainbard/Documents/Discovrd/Discovrd.xcodeproj/project.pbxproj", "w") as f:
    f.write(pbx)

print("Updated project.pbxproj with explicit paths.")
