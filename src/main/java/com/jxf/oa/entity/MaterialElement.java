package com.jxf.oa.entity;

public class MaterialElement {

	private Integer elementidentity;
	private String elementId;
	private String materialtype;
	private String pinming;
	private Double thickness;
	private String color;
	private Double weight;
	private Double length;
	private Integer count;
	private Double totalWeight;
	private Integer riskcount;
	private Integer riskflag;// 0 for OK, 1 for risk

	private String materialchildren;

	public MaterialElement() {
	}

	public Integer getElementidentity() {
		return elementidentity;
	}

	public void setElementidentity(Integer elementidentity) {
		this.elementidentity = elementidentity;
	}

	

	public String getElementId() {
		return elementId;
	}

	public void setElementId(String elementId) {
		this.elementId = elementId;
	}

	public String getMaterialtype() {
		return materialtype;
	}

	public void setMaterialtype(String materialtype) {
		this.materialtype = materialtype;
	}

	
	public String getPinming() {
		return pinming;
	}

	public void setPinming(String pinming) {
		this.pinming = pinming;
	}

	public Double getThickness() {
		return thickness;
	}

	public void setThickness(Double thickness) {
		this.thickness = thickness;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public Double getWeight() {
		return weight;
	}

	public void setWeight(Double weight) {
		this.weight = weight;
	}

	public Double getLength() {
		return length;
	}

	public void setLength(Double length) {
		this.length = length;
	}

	public Integer getCount() {
		return count;
	}

	public void setCount(Integer count) {
		this.count = count;
	}

	public Double getTotalWeight() {
		return totalWeight;
	}

	public void setTotalWeight(Double totalWeight) {
		this.totalWeight = totalWeight;
	}

	public Integer getRiskcount() {
		return riskcount;
	}

	public void setRiskcount(Integer riskcount) {
		this.riskcount = riskcount;
	}

	public Integer getRiskflag() {
		return riskflag;
	}

	public void setRiskflag(Integer riskflag) {
		this.riskflag = riskflag;
	}

	

	public String getMaterialchildren() {
		return materialchildren;
	}

	public void setMaterialchildren(String materialchildren) {
		this.materialchildren = materialchildren;
	}

	public MaterialElement getElement(Material material) {
		MaterialElement me = new MaterialElement();
		me.setMaterialtype("material");
		me.setElementidentity(material.getId());
		//me.setMaterialidentity(material.getId());
		me.setElementId(material.getMaterialId());
		me.setThickness(material.getThickness());
		me.setColor(material.getColor());
		me.setLength(material.getLength());
		me.setCount(material.getCount());
		return me;
	}

	public MaterialElement getElement(MaterialGroup materialgroup) {
		MaterialElement me = new MaterialElement();
		me.setMaterialtype("materialtype");
		//me.setMaterialgroupidentity(materialgroup.getId());
		me.setElementidentity(materialgroup.getId());
		me.setElementId(materialgroup.getMaterialgroupId());
		me.setMaterialchildren(materialgroup.getMaterialchildren());
		return me;
	}

}
