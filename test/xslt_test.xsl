<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- simple xslt which transforms div into span -->
<xsl:template match="/">
<xsl:apply-templates select="*"/>
</xsl:template>


<xsl:template match="div">
<span><xsl:apply-templates/></span>
</xsl:template>

</xsl:stylesheet>
