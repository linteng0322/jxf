package com.jxf.oa.entity;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.validator.constraints.NotBlank;
@Entity
@Table(name = "MATERIAL")
public class Material extends IdEntity {
	
	
	private Integer id;
	private String materialId;
	private String pinming;
	private Double thickness;
	private String thicknessunit="mm";
	private String color;
	private Double weight;
	private String weightunit="kg";
	private Double length;
	private String lengthunit="m";
	private Integer count;
	private Double totalWeight;
	private Integer riskcount;
	private Integer riskflag;//0 for OK, 1 for risk

    public Material() {
    }

    public Material(Integer id) {
        this.id = id;
    }

    @Id
    @Column(name = "ID")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }
    
	@Column(name = "MATERIALID", nullable = false, length = 20)
    public String getMaterialId() {
		return materialId;
	}

	public void setMaterialId(String materialId) {
		this.materialId = materialId;
	}

	@Column(name = "PINMING")
    public String getPinming() {
		return pinming;
	}

	public void setPinming(String pinming) {
		this.pinming = pinming;
	}
	
	@Column(name = "THICKNESS", nullable = false, length = 20 )
	public Double getThickness() {
		return thickness;
	}

	public void setThickness(Double thickness) {
		this.thickness = thickness;
	}
	
	@Column(name = "THICKNESSUNIT")
	public String getThicknessunit() {
		return thicknessunit;
	}

	public void setThicknessunit(String thicknessunit) {
		this.thicknessunit = thicknessunit;
	}
	
	
	@Column(name = "COLOR")
	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}
	
	@Column(name = "WEIGHT", nullable = false, length = 20 )
	public Double getWeight() {
		return weight;
	}

	public void setWeight(Double weight) {
		this.weight = weight;
	}
	
	@Column(name = "WEIGHTUNIT")
	public String getWeightunit() {
		return weightunit;
	}

	public void setWeightunit(String weightunit) {
		this.weightunit = weightunit;
	}

	@Column(name = "LENGTH", nullable = false, length = 20 )
	public Double getLength() {
		return length;
	}

	public void setLength(Double length) {
		this.length = length;
	}
	
	
	@Column(name = "LENGTHUNIT")
	public String getLengthunit() {
		return lengthunit;
	}

	public void setLengthunit(String lengthunit) {
		this.lengthunit = lengthunit;
	}

	@Column(name = "COUNT")
	public Integer getCount() {
		return count;
	}

	public void setCount(Integer count) {
		this.count = count;
	}
	
	@Column(name = "TOTALWEIGHT")
	public Double getTotalWeight() {
		if(this.count!=null&&this.weight!=null&&this.length!=null){
			return this.count*this.weight*this.length;
		}
		return totalWeight;
	}

	public void setTotalWeight(Double totalWeight) {
		this.totalWeight = totalWeight;
	}

	@Column(name = "RISKCOUNT")
	public Integer getRiskcount() {
		return riskcount;
	}

	public void setRiskcount(Integer riskcount) {
		this.riskcount = riskcount;
	}

	@Column(name = "RISKFLAG")
	public Integer getRiskflag() {
		return riskflag;
	}

	public void setRiskflag(Integer riskflag) {
		this.riskflag = riskflag;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Material other = (Material) obj;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		return true;
	}

   

}
