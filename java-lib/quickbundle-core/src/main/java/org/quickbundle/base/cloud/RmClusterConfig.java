package org.quickbundle.base.cloud;

import java.lang.reflect.InvocationTargetException;
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.Node;
import org.quickbundle.base.cache.RmCacheHandler;
import org.quickbundle.base.web.servlet.RmHolderServlet;
import org.quickbundle.project.cloud.HostInfo;
import org.quickbundle.project.init.RmConfig;
import org.quickbundle.util.RmSequenceMap;

public class RmClusterConfig {

	private static HostInfo localhostInfo = null;
	private static volatile boolean isInit = false;

	public static void initLocalhostInfo(HttpServletRequest request) {
		if (!isInit) {
			synchronized (RmClusterConfig.class) {
				if (!isInit) {
					localhostInfo = new HostInfo();
					localhostInfo.setScheme(request.getScheme());
					localhostInfo.setServerName(request.getServerName());
					localhostInfo.setServerPort(request.getServerPort());
					localhostInfo.setContextPath(request.getContextPath());
					isInit = true;
				}
			}
		}
	}

	public static HostInfo getLocalhostInfo() {
		return localhostInfo;
	}

	static Document getRmClusterDoc() {
		Class clz = null;
		Object doc = null;
		try {
			clz = Class.forName("org.quickbundle.project.RmProjectHelper");
			doc = clz.getMethod("getRmClusterDoc").invoke(clz, new Object[] {});
		} catch (ClassNotFoundException e) {
			throw new RuntimeException(e);
		} catch (NoSuchMethodException e) {
			throw new RuntimeException(e);
		} catch (IllegalArgumentException e) {
			throw new RuntimeException(e);
		} catch (SecurityException e) {
			throw new RuntimeException(e);
		} catch (IllegalAccessException e) {
			throw new RuntimeException(e);
		} catch (InvocationTargetException e) {
			throw new RuntimeException(e);
		}
		return (Document) doc;
	}

	static String guessSelfId() {
		if (localhostInfo == null) {
			return null;
		}
		List nodes = getRmClusterDoc().selectNodes("/rm/org.quickbundle.base.cloud.RmClusterConfig/node");
		for (Object nodeObj : nodes) {
			Element node = (Element) nodeObj;
			if (node.valueOf("urlPrefix").startsWith(localhostInfo.getLocalhostUrl())) {
				return node.valueOf("@id");
			}
		}
		return null;
	}

	private static Element getSelfNode() {
		if (RmConfig.systemDebugMode()) {
			String guessSelfId = guessSelfId();
			if (guessSelfId != null && guessSelfId.length() > 0) {
				return (Element) getRmClusterDoc().selectSingleNode("/rm/org.quickbundle.base.cloud.RmClusterConfig/node[@id='" + guessSelfId + "']");
			}
		}
		return (Element) getRmClusterDoc().selectSingleNode("/rm/org.quickbundle.base.cloud.RmClusterConfig/node[@id=../@thisId]");
	}

	/**
	 * 获得contextPath
	 * 
	 * @return
	 */
	public static String getContextPath() {
		if (getLocalhostInfo() != null) {
			return getLocalhostInfo().getContextPath();
		} else if (RmHolderServlet.getDefaultServletContext() != null) {
			try {
				return RmHolderServlet.getDefaultServletContext().getContextPath();
			} catch (Throwable e) {
				RmCacheHandler.logCache.error("JavaEE version to low: " + e.toString());
			}
		}
		return getSelfNode().valueOf("contextPath");
	}

	/**
	 * 获得集群模式下本节点的id
	 * 
	 * @return
	 */
	public static String getSelfId() {
		if (RmConfig.isCloudNodeInfoAuto()) {
			try {
				return InetAddress.getLocalHost().toString();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return getSelfNode().valueOf("@id");
	}

	/**
	 * 获得集群模式下本节点的webservice地址前缀
	 * 
	 * @return
	 */
	public static String getSelfWsUrl() {
		if (RmConfig.isCloudNodeInfoAuto() && localhostInfo != null) {
			String localhost = localhostInfo.getScheme() + "://" + localhostInfo.getServerName() + ":" + localhostInfo.getServerPort();
			return localhost + getContextPath() + "/services/";
		}
		return getSelfNode().valueOf("webServiceUrl");
	}

	public static String getWsUrl(String serverId) {
		if (serverId == null) {
			return null;
		}
		Element node = (Element) getRmClusterDoc().selectSingleNode("/rm/org.quickbundle.base.cloud.RmClusterConfig/node[@id='" + serverId + "']");
		if (node == null) {
			return null;
		}
		return node.valueOf("webServiceUrl");
	}

	public static String getUrlPrefix(String serverId) {
		if (serverId == null) {
			return null;
		}
		Element node = (Element) getRmClusterDoc().selectSingleNode("/rm/org.quickbundle.base.cloud.RmClusterConfig/node[@id='" + serverId + "']");
		if (node == null) {
			return null;
		}
		return node.valueOf("urlPrefix");
	}

	/**
	 * 获得集群模式下其他节点的webservice地址前缀
	 * 
	 * @return
	 */
	public static Map<String, String> getOtherWsUrl() {
		String thisId = getSelfId();
		List<Element> lOther = getRmClusterDoc().selectNodes("/rm/org.quickbundle.base.cloud.RmClusterConfig/node[not(@id='" + thisId + "')]");
		Map<String, String> mUrl = new RmSequenceMap<String, String>();
		for (Element ele : lOther) {
			mUrl.put(ele.valueOf("@id"), ele.valueOf("webServiceUrl"));
		}
		return mUrl;
	}

	public static List<String> getOtherNodeId() {
		String thisId = getSelfId();
		List<Element> lOther = getRmClusterDoc().selectNodes("/rm/org.quickbundle.base.cloud.RmClusterConfig/node[not(@id='" + thisId + "')]");
		List<String> lNodeId = new ArrayList<String>();
		for (Element ele : lOther) {
			lNodeId.add(ele.valueOf("@id"));
		}
		return lNodeId;
	}

	public static Map<String, String> getAuth(String serverId) {
		final Node node = getRmClusterDoc().selectSingleNode("/rm/org.quickbundle.base.cloud.RmClusterConfig/node[@id='" + serverId + "']");
		return new HashMap<String, String>() {
			{
				this.put(node.valueOf("user"), node.valueOf("password"));
			}
		};
	}

	public static void main(String[] args) {
		System.out.println(getLocalhostInfo());
		System.out.println(getContextPath());
		System.out.println(getSelfId());
		System.out.println(getSelfWsUrl());
		System.out.println(getOtherWsUrl());
		System.out.println(getAuth("server1"));
	}
}