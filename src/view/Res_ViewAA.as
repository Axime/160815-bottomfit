package view {
	import d2.axime.display.ViewAA;
	import d2.axime.events.AEvent;
	import d2.axime.resource.AssetMachine;
	import d2.axime.resource.EmbeddedBundle;
	import d2.axime.resource.FilesBundle;
	import d2.axime.resource.handlers.TextureAA_BundleHandler;
	
	import res.ResCoreUtil;
	
	import view.res.Res_StateAA;
	
public class Res_ViewAA extends ViewAA {
	
	public function Res_ViewAA( RM:AssetMachine, callback:Function, preRM:AssetMachine = null ) {
		m_RM = RM;
		m_callback = callback;
		m_preRM = preRM;
	}
	
	public static var g_AM:AssetMachine;
	public static function getRes() : AssetMachine {
		var filenameList:Vector.<String>;
		
		if(!g_AM) {
			g_AM = new AssetMachine("common/", false);
//			g_AM.addBundle(new EmbeddedBundle(ResCoreUtil.img),   new TextureAA_BundleHandler(1.0, false, false, "image"));
//			g_AM.addBundle(new EmbeddedBundle(ResCoreUtil.img2),  new TextureAA_BundleHandler(2.0, true,  true,  "image"));
//			g_AM.addBundle(new EmbeddedBundle(ResCoreUtil.atlas), new AtlasAA_BundleHandler(1.0,   false, false, "image"));
//			g_AM.addBundle(new EmbeddedBundle(ResCoreUtil.atf),   new ATF_BundleHandler(false, 1.0, null, "atf"));
//			g_AM.addBundle(new EmbeddedBundle(ResCoreUtil.atf2),  new ATF_BundleHandler(false, 2.0, null, "atf"));
//			g_AM.addBundle(new EmbeddedBundle(ResCoreUtil.atf2m), new ATF_BundleHandler(true,  2.0, null, "atf"));
//			g_AM.addBundle(new EmbeddedBundle(ResCoreUtil.frameClip), new FrameClip_BundleHandler);
			
//			g_AM.addBundle(new EmbeddedBundle(ResCoreUtil.ui),    new TextureAA_BundleHandler(1.0, false, false, "image"));
			
			filenameList = new <String>["img/frame.png"];
			g_AM.addBundle(new FilesBundle(filenameList), new TextureAA_BundleHandler(1.0));
		}
		return g_AM;
	}
	
	override public function onViewAdded() : void {
		if(m_preRM != null) {
			m_preRM.addEventListener(AEvent.COMPLETE, ____preCompleted);
		}
		else {
			this.____doStartLoad();
		}
	}
	
	
	
	private var m_RM:AssetMachine;
	private var m_callback:Function;
	private var m_preRM:AssetMachine;
	
	
	
	private function ____preCompleted( e:AEvent ) : void {
		m_preRM.removeEventListener(AEvent.COMPLETE, ____preCompleted);
		
		this.____doStartLoad();
	}
	
	private function ____doStartLoad() : void {
		this.setState(new Res_StateAA(m_RM, m_callback));
	}
}
}