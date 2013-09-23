package org.quickbundle.itf.base;

public interface IRmIdGenerator {
	public void initBeanFactory();
	public String[] requestIdInner(String tableName, int length);
}
