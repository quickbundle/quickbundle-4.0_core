package org.quickbundle.itf.base;

public interface IRmIdFactory {
	public void initBeanFactory();
	public String[] requestIdInner(String tableName, int length);
}
