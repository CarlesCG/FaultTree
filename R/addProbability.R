# addProbability.R
# copyright 2015, openreliability.org
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

addProbability<-function(DF, at, prob, display_under=NULL, tag="", name="", name2="", description="")  {

 	tp=4

	info<-test.basic(DF, at,  display_under, tag)
	thisID<-info[1]
	parent<-info[2]
	gp<-info[3]
	condition<-info[4]

	if(prob<0 || prob>1)  {stop("probability entry must be between zero and one")}

	Dfrow<-data.frame(
		ID=	thisID	,
		GParent=	gp	,
		CParent=	at	,
		Level=	DF$Level[parent]+1	,
		Type=	tp	,
		CFR=	-1	,
		PBF=	prob	,
		CRT=	-1	,
		MOE=	0	,
		PHF_PZ=	-1	,
		Condition=	condition,
		Cond_Code=	0,
		Interval=	-1	,
		Tag_Obj=	tag	,
		Name=	name	,
		Name2=	name2	,
		Description=	description	,
		Unused1=	""	,
		Unused2=	""
	)


	DF<-rbind(DF, Dfrow)
	DF
}
