<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="filename"/>
    <xsl:param name="channel"/>
    <!-- Identity template to copy everything by default -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Template to match the section where items will be added -->
    <xsl:template match="/settings">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <!-- Add items from the source XML here -->
            <xsl:for-each select="document($filename)//channel[@site_id=$channel]">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
