<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:tbx="urn:iso:std:iso:30042:ed-1"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:oasis="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
  exclude-result-prefixes="xlink tbx mml xi oasis">

  <xsl:output method="html" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compat"/>

  <xsl:param name="image_path_prefix" select="''"/>
  <xsl:param name="image_file_extension" select="'.png'"/>

  
  <xsl:template match="/">
    <html>
      <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>
          <xsl:choose>
            <xsl:when test="//std-meta//title-wrap//main-title | //std-meta//title-wrap//full">
              <xsl:value-of select="normalize-space((//std-meta//title-wrap//main-title | //std-meta//title-wrap//full)[1])"/>
            </xsl:when>
            <xsl:when test="//title-wrap//main-title | //title-wrap//full">
              <xsl:value-of select="normalize-space((//title-wrap//main-title | //title-wrap//full)[1])"/>
            </xsl:when>
            <xsl:when test="//title[1]">
              <xsl:value-of select="normalize-space(//title[1])"/>
            </xsl:when>
            <xsl:otherwise>NISO STS Document</xsl:otherwise>
          </xsl:choose>
        </title>
        <link rel="stylesheet" href="niso-to-html.scss"/>
      </head>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="standard | adoption">
    <main class="standard-document">
      <xsl:apply-templates/>
    </main>
  </xsl:template>

  <xsl:template match="front | adoption-front">
    <div class="document-front">
      <xsl:apply-templates select="std-meta | iso-meta | reg-meta | nat-meta | adoption-meta"/>
      <xsl:apply-templates select="*[not(self::std-meta or self::iso-meta or self::reg-meta or self::nat-meta or self::adoption-meta)]"/>
    </div>
  </xsl:template>

  <xsl:template match="std-meta | iso-meta | reg-meta | nat-meta">
    <div class="document-meta">
      <xsl:apply-templates select="title-wrap"/>
      <div class="std-meta-items">
        <xsl:apply-templates select="*[not(self::title-wrap)]"/>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="adoption-meta">
    <div class="adoption-meta">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="title-wrap">
    <div class="title-wrap">
      <xsl:if test="intro">
        <p class="intro"><xsl:value-of select="intro"/></p>
      </xsl:if>
      <xsl:if test="main">
        <h1 class="main-title"><xsl:value-of select="main"/></h1>
      </xsl:if>
      <xsl:if test="full and not(main)">
        <h1 class="main-title"><xsl:value-of select="full"/></h1>
      </xsl:if>
      <xsl:if test="full and main">
        <p class="full-title"><strong><xsl:value-of select="full"/></strong></p>
      </xsl:if>
    </div>
  </xsl:template>
  
  <xsl:template match="doc-ref"/>
  
  <xsl:template match="self-uri">
    <div class="self-uri">
      <strong>URI: </strong>
      <a href="{.}"><xsl:value-of select="."/></a>
    </div>
  </xsl:template>

  <xsl:template match="doc-type">
    <div class="doc-type">
      <strong>Document Type: </strong><xsl:value-of select="."/>
    </div>
  </xsl:template>

  <xsl:template match="doc-number">
    <div class="doc-number">
      <strong>Document Number: </strong><xsl:value-of select="."/>
    </div>
  </xsl:template>

  <xsl:template match="part-number[normalize-space()]">
    <div class="part-number">
      <strong>Part Number: </strong><xsl:value-of select="."/>
    </div>
  </xsl:template>

  <xsl:template match="std-ident">
    <div class="std-ident">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="originator">
    <div class="std-ident">
      <strong>Originator: </strong><xsl:value-of select="."/>
    </div>
  </xsl:template>

  <xsl:template match="content-language">
    <div class="content-language">
      <strong>Language Content: </strong><xsl:value-of select="."/>
    </div>
  </xsl:template>

  <xsl:template match="proj-id[normalize-space()]">
    <div class="proj-id">
      <strong>Project ID: </strong><xsl:value-of select="."/>
    </div>
  </xsl:template>

  <xsl:template match="std-org[parent::std-meta]">
    <div class="std-org">
      <strong>Organization: </strong>
      <xsl:choose>
        <xsl:when test="std-org-name">
          <xsl:value-of select="std-org-name"/>
          <xsl:if test="std-org-abbrev">
            (<xsl:value-of select="std-org-abbrev"/>)
          </xsl:if>
        </xsl:when>
        <xsl:when test="std-org-abbrev">
          <xsl:value-of select="std-org-abbrev"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template match="std-ref[parent::std-meta]">
    <div class="std-ref-line">
        <xsl:if test="@type='dated'"><strong>Dated: </strong></xsl:if>
        <xsl:if test="@type='undated'"><strong>Undated: </strong></xsl:if>
        <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="release-version[normalize-space()]">
    <div class="release-version">
      <strong>Release: </strong><xsl:value-of select="."/>
    </div>
  </xsl:template>
  
  <xsl:template match="release-date">
    <xsl:variable name="dateValue" select="normalize-space(@iso-8601-date | @date | .)" />
    <xsl:if test="$dateValue != ''">
        <div class="release-date">
            <strong>
                Date
                <xsl:if test="@std-type">
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="@std-type"/>
                    <xsl:if test="@date-type">, <xsl:value-of select="@date-type"/></xsl:if>
                    <xsl:text>)</xsl:text>
                </xsl:if>
                <xsl:if test="not(@std-type) and @date-type">
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="@date-type"/>
                    <xsl:text>)</xsl:text>
                </xsl:if>
                :
            </strong>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$dateValue"/>
        </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="comm-ref">
    <div class="comm-ref">
      <strong>Committee: </strong><xsl:value-of select="."/>
    </div>
  </xsl:template>

  <xsl:template match="ics">
    <div class="ics">
      <strong>ICS: </strong><xsl:value-of select="."/>
    </div>
  </xsl:template>
  
  <xsl:template match="isbn">
    <div class="isbn">
      <strong>ISBN: </strong><xsl:value-of select="."/>
    </div>
  </xsl:template>
  
  <xsl:template match="edition | version">
    <xsl:if test="normalize-space(.) != ''">
      <div class="edition-version">
        <xsl:if test="self::edition">
          <strong>Edition: </strong><xsl:value-of select="."/>
        </xsl:if>
        <xsl:if test="self::version">
          <strong>Version: </strong><xsl:value-of select="."/>
        </xsl:if>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="secretariat">
    <div class="secretariat">
      <strong>Secretariat: </strong><xsl:value-of select="."/>
    </div>
  </xsl:template>

  <xsl:template match="page-count">
    <div class="page-count">
      <strong>Pages: </strong><xsl:value-of select="@count"/>
    </div>
  </xsl:template>

  <xsl:template match="std-xref">
    <xsl:if test="std-ref[normalize-space(.) != '']">
      <div class="std-xref">
        <xsl:apply-templates/>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="custom-meta-group">
    <xsl:for-each select="custom-meta">
      <div class="custom-meta">
        <strong><xsl:value-of select="meta-name"/>: </strong>
        <xsl:value-of select="meta-value"/>
      </div>
    </for-each>
  </xsl:template>
  
  <xsl:template match="permissions">
    <div class="permissions">
      <xsl:apply-templates select="copyright-statement"/>
      <p>
        <xsl:apply-templates select="copyright-year"/>
        <xsl:apply-templates select="copyright-holder"/>
      </p>
    </div>
  </xsl:template>
  
  <xsl:template match="copyright-statement">
    <p class="copyright-statement">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="copyright-year">
    <span class="copyright-year">© <xsl:value-of select="."/></span>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="copyright-holder">
    <span class="copyright-holder">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template match="abstract">
    <section class="abstract">
      <xsl:if test="not(title)">
        <h3>Abstract</h3>
      </xsl:if>
      <xsl:apply-templates/>
    </section>
  </xsl:template>

  <xsl:template match="body">
    <div class="body">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="sec">
    <section class="sec">
      <xsl:if test="@id">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </section>
  </xsl:template>

  <xsl:template match="sec/title">
    <xsl:variable name="base-level">
      <xsl:choose>
        <xsl:when test="ancestor::app or ancestor::annex">3</xsl:when>
        <xsl:otherwise>2</xsl:otherwise>
      </choose>
    </xsl:variable>
    <xsl:variable name="level" select="$base-level + count(ancestor::sec)"/>
    <xsl:element name="h{$level}">
      <xsl:if test="preceding-sibling::label">
        <span class="label">
          <xsl:value-of select="preceding-sibling::label"/>
          <xsl:text> </xsl:text>
        </span>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

<xsl:template match="label">
  <xsl:if test="not(following-sibling::title)
                and not(parent::table-wrap)
                and not(parent::fig)
                and not(parent::app)
                and not(ancestor::fn)
                and not(ancestor::fn-group)">
    <span class="label">
      <xsl:apply-templates/>
    </span>
  </xsl:if>
</xsl:template>

  <xsl:template match="p">
    <p>
      <xsl:if test="@id">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="bold | b | strong">
    <strong><xsl:apply-templates/></strong>
  </xsl:template>

  <xsl:template match="italic | i | emph">
    <em><xsl:apply-templates/></em>
  </xsl:template>

  <xsl:template match="underline | u">
    <u><xsl:apply-templates/></u>
  </xsl:template>

  <xsl:template match="monospace">
    <code><xsl:apply-templates/></code>
  </xsl:template>

  <xsl:template match="sup">
    <sup><xsl:apply-templates/></sup>
  </xsl:template>

  <xsl:template match="sub">
    <sub><xsl:apply-templates/></sub>
  </xsl:template>

  <xsl:template match="break">
    <br/>
  </xsl:template>

  <xsl:template match="styled-content">
    <span>
      <xsl:if test="@style">
        <xsl:attribute name="style"><xsl:value-of select="@style"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="@style-type">
        <xsl:attribute name="class"><xsl:value-of select="@style-type"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="abbrev">
    <abbr>
      <xsl:if test="@xlink:title">
        <xsl:attribute name="title"><xsl:value-of select="@xlink:title"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </abbr>
  </xsl:template>

  <xsl:template match="list[@list-type='bullet'] | list[not(@list-type)]">
    <ul>
      <xsl:apply-templates select="list-item"/>
    </ul>
  </xsl:template>

  <xsl:template match="list[@list-type='order' or @list-type='arabic' or @list-type='alpha-lower' or @list-type='alpha-upper' or @list-type='roman-lower' or @list-type='roman-upper']">
    <ol>
      <xsl:if test="@list-type='alpha-lower'">
        <xsl:attribute name="style">list-style-type: lower-alpha;</xsl:attribute>
      </xsl:if>
      <xsl:if test="@list-type='alpha-upper'">
        <xsl:attribute name="style">list-style-type: upper-alpha;</xsl:attribute>
      </xsl:if>
      <xsl:if test="@list-type='roman-lower'">
        <xsl:attribute name="style">list-style-type: lower-roman;</xsl:attribute>
      </xsl:if>
      <xsl:if test="@list-type='roman-upper'">
        <xsl:attribute name="style">list-style-type: upper-roman;</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="list-item"/>
    </ol>
  </xsl:template>

  <xsl:template match="list[@list-type='simple']">
    <div class="list-simple">
      <xsl:apply-templates select="list-item"/>
    </div>
  </xsl:template>

  <xsl:template match="list-item">
    <li class="list-item">
      <xsl:if test="label and not(parent::list[@list-type='order' or @list-type='arabic' or @list-type='alpha-lower' or @list-type='alpha-upper' or @list-type='roman-lower' or @list-type='roman-upper']) and not(contains(label, '—')) and not(contains(label, '-')) and normalize-space(label) != ''">
        <span class="label"><xsl:value-of select="label"/></span>
      </xsl:if>
      <xsl:apply-templates select="*[not(self::label)]"/>
    </li>
  </xsl:template>

  <xsl:template match="def-list">
    <dl class="def-list">
      <xsl:apply-templates/>
    </dl>
  </xsl:template>

  <xsl:template match="def-item">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="term">
    <dt class="def-term">
      <xsl:apply-templates/>
    </dt>
  </xsl:template>

  <xsl:template match="def">
    <dd class="def">
      <xsl:apply-templates/>
    </dd>
  </xsl:template>

  <xsl:template match="table-wrap">
    <xsl:if test="caption/title">
      <h3 class="table-title-heading">
        <xsl:value-of select="caption/title"/>
      </h3>
    </xsl:if>
    <div class="table-wrap">
      <xsl:if test="@id">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="caption/*[not(self::title)]">
          <xsl:apply-templates select="caption"/>
      </xsl:if>
      <xsl:apply-templates select="table | oasis:table"/>
      <xsl:apply-templates select="table-wrap-foot"/>
    </div>
  </xsl:template>
  
  <xsl:template match="array">
    <div class="array-layout-table">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="table-wrap/caption">
    <div class="table-caption">
      <xsl:if test="preceding-sibling::label">
        <xsl:value-of select="preceding-sibling::label"/>
        <xsl:text> — </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="*[not(self::title)]"/>
    </div>
  </xsl:template>

  <xsl:template match="table-wrap/caption/title | table-wrap/label">
  </xsl:template>

  <xsl:template match="table | oasis:table">
    <table>
      <xsl:if test="@id">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </table>
  </xsl:template>

  <xsl:template match="colgroup">
    <colgroup>
      <xsl:apply-templates select="col"/>
    </colgroup>
  </xsl:template>

  <xsl:template match="col">
    <col>
      <xsl:if test="@width">
        <xsl:attribute name="style">width: <xsl:value-of select="@width"/></xsl:attribute>
      </xsl:if>
    </col>
  </xsl:template>

  <xsl:template match="thead">
    <thead>
      <xsl:apply-templates/>
    </thead>
  </xsl:template>

  <xsl:template match="tbody">
    <tbody>
      <xsl:apply-templates/>
    </tbody>
  </xsl:template>

  <xsl:template match="tfoot">
    <tfoot>
      <xsl:apply-templates/>
    </tfoot>
  </xsl:template>

  <xsl:template match="tr">
    <tr>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>

  <xsl:template match="th">
    <th>
      <xsl:if test="@colspan">
        <xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="@rowspan">
        <xsl:attribute name="rowspan"><xsl:value-of select="@rowspan"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="@align">
        <xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </th>
    </xsl:template>

  <xsl:template match="td">
    <td>
      <xsl:if test="@colspan">
        <xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="@rowspan">
        <xsl:attribute name="rowspan"><xsl:value-of select="@rowspan"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="@align">
        <xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </td>
  </xsl:template>

  <xsl:template match="table-wrap-foot">
    <div class="table-foot">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="fig">
    <figure class="fig">
      <xsl:if test="@id">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="caption"/>
      <xsl:apply-templates select="graphic | inline-graphic"/>
      <xsl:apply-templates select="legend"/>
      <xsl:apply-templates select="*[not(self::label or self::caption or self::graphic or self::inline-graphic or self::legend)]"/>
    </figure>
  </xsl:template>

  <xsl:template match="legend">
    <div class="fig-legend">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="fig/caption">
    <figcaption class="fig-caption">
      <xsl:if test="preceding-sibling::label">
        <xsl:value-of select="preceding-sibling::label"/>
        <xsl:text> — </xsl:text>
      </xsl:if>
      <xsl:if test="title">
        <xsl:value-of select="title"/>
      </xsl:if>
    </figcaption>
  </xsl:template>

  <xsl:template match="fig/caption/title | fig/label">
  </xsl:template>

  <xsl:template match="graphic | inline-graphic">
    <xsl:variable name="href" select="@xlink:href | @href"/>
    <xsl:if test="$href and normalize-space($href) != ''">
      <xsl:variable name="filename">
        <xsl:choose>
          <xsl:when test="contains($href, '/')">
            <xsl:call-template name="get-filename">
              <xsl:with-param name="path" select="$href"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$href"/>
          </xsl:otherwise>
        </choose>
      </xsl:variable>
      <xsl:variable name="src">
        <xsl:choose>
          <xsl:when test="contains($filename, '.png') or contains($filename, '.jpg') or contains($filename, '.jpeg') or contains($filename, '.gif') or contains($filename, '.svg') or contains($filename, '.bmp') or contains($filename, '.webp')">
            <xsl:value-of select="concat($image_path_prefix, $filename)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat($image_path_prefix, $filename, $image_file_extension)"/>
          </xsl:otherwise>
        </choose>
      </xsl:variable>
      <img src="{$src}">
        <xsl:attribute name="alt">
          <xsl:choose>
            <xsl:when test="alt-text">
              <xsl:value-of select="normalize-space(alt-text)"/>
            </xsl:when>
            <xsl:otherwise>Image</xsl:otherwise>
          </choose>
        </xsl:attribute>
      </img>
    </xsl:if>
  </xsl:template>

  <xsl:template name="get-filename">
    <xsl:param name="path"/>
    <xsl:choose>
      <xsl:when test="contains($path, '/')">
        <xsl:call-template name="get-filename">
          <xsl:with-param name="path" select="substring-after($path, '/')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$path"/>
      </xsl:otherwise>
    </choose>
  </xsl:template>

  <xsl:template match="disp-formula">
    <div class="disp-formula">
      <xsl:if test="@id">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="inline-formula">
    <span class="inline-formula">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="mml:math">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="term-sec">
    <section class="term-sec" id="{@id}">
      <xsl:if test="label">
        <h4 class="term-label">
          <xsl:value-of select="label"/>
        </h4>
      </xsl:if>
      <xsl:apply-templates select="tbx:termEntry"/>
    </section>
  </xsl:template>

  <xsl:template match="tbx:termEntry">
    <div class="tbx-term-entry" id="{@id}">
      <xsl:apply-templates select="tbx:langSet"/>
    </div>
  </xsl:template>

  <xsl:template match="tbx:langSet">
    <div class="tbx-langset">
      <xsl:apply-templates select="tbx:definition"/>
      <xsl:apply-templates select="tbx:source"/>
      <xsl:apply-templates select="tbx:tig"/>
    </div>
  </xsl:template>

  <xsl:template match="tbx:definition">
    <div class="tbx-definition">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="tbx:tig">
    <div class="tbx-tig">
      <xsl:apply-templates select="tbx:term"/>
    </div>
  </xsl:template>

  <xsl:template match="tbx:term">
    <div class="tbx-term">
      <strong>
        <xsl:apply-templates/>
      </strong>
    </div>
  </xsl:template>

  <xsl:template match="tbx:source">
    <div class="tbx-source">
      <small style="color: #6c757d; font-style: italic;">
        <xsl:apply-templates/>
      </small>
    </div>
  </xsl:template>

  <xsl:template match="tbx:partOfSpeech">
  </xsl:template>

  <xsl:template match="non-normative-note">
    <div class="non-normative-note">
      <xsl:if test="@id">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="note">
    <div class="note">
      <xsl:if test="@id">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="non-normative-example">
    <div class="non-normative-example">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="example">
    <div class="example">
      <strong>Example</strong>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="statement">
    <div class="statement">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="boxed-text">
    <div class="boxed-text">
      <xsl:if test="@id">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="preformat | code">
    <pre>
      <xsl:apply-templates/>
    </pre>
  </xsl:template>

  <xsl:template match="back">
    <footer class="back">
      <xsl:apply-templates/>
    </footer>
  </xsl:template>

  <xsl:template match="ref-list">
    <section class="ref-list">
      <xsl:if test="title">
        <xsl:apply-templates select="title"/>
      </xsl:if>
      <xsl:if test="not(title)">
        <h2>References</h2>
      </xsl:if>
      <xsl:apply-templates select="*[not(self::title)]"/>
    </section>
  </xsl:template>
  
  <xsl:template match="ref-list/title">
    <h2>
      <xsl:apply-templates/>
    </h2>
  </xsl:template>

  <xsl:template match="ref">
    <xsl:if test=".//text()[normalize-space() != '' and not(ancestor::label)] or not(label)">
      <div class="ref">
        <xsl:if test="@id">
          <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
        </xsl:if>
        <xsl:apply-templates select="label"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="*[not(self::label)] | text()[normalize-space(.)!='']"/>
      </div>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="fn">
    <div class="ref">
      <xsl:if test="@id">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>
      <xsl:if test="label">
        <span class="label">
          [<xsl:value-of select="label"/>]
        </span>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates select="*[not(self::label)]"/>
    </div>
  </xsl:template>

  <xsl:template match="element-citation | mixed-citation | nlm-citation">
    <span class="citation">
      <xsl:choose>
     <xsl:when test=".//string-name | .//person-group/string-name | .//person-group/name | .//name">
          <xsl:variable name="authors" select=".//string-name | .//person-group/string-name | .//person-group/name | .//name"/>
          <xsl:if test="$authors">
            <strong>
              <xsl:for-each select="$authors">
                <xsl:choose>
                  <xsl:when test="surname">
                    <xsl:value-of select="normalize-space(surname)"/>
                    <xsl:if test="given-names">
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="normalize-space(given-names)"/>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(.)"/>
                  </xsl:otherwise>
                </choose>
                <xsl:if test="position() != last()">
                  <xsl:text>, </xsl:text>
                </xsl:if>
              </for-each>
            </strong>
            <xsl:text>. </xsl:text>
          </xsl:if>
          <xsl:if test=".//article-title[1]">
            <xsl:value-of select="normalize-space(.//article-title[1])"/>
            <xsl:text>. </xsl:text>
          </xsl:if>
          <xsl:if test=".//source[1]">
            <em><xsl:value-of select="normalize-space(.//source[1])"/></em>
            <xsl:text> </xsl:text>
          </xsl:if>
          <xsl:if test=".//year[1]">
            <xsl:value-of select="normalize-space(.//year[1])"/>
          </xsl:if>
          <xsl:if test=".//volume[1]">
            <xsl:text>, </xsl:text>
            <strong><xsl:value-of select="normalize-space(.//volume[1])"/></strong>
          </xsl:if>
          <xsl:if test=".//fpage[1]">
            <xsl:text>: </xsl:text>
            <xsl:value-of select="normalize-space(.//fpage[1])"/>
            <xsl:if test=".//lpage[1]">
              <xsl:text>–</xsl:text>
              <xsl:value-of select="normalize-space(.//lpage[1])"/>
            </xsl:if>
          </xsl:if>
          <xsl:if test=".//publisher-name[1]">
            <xsl:value-of select="normalize-space(.//publisher-name[1])"/>
            <xsl:if test=".//publisher-loc[1]">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:if>
          <xsl:if test=".//publisher-loc[1]">
            <xsl:value-of select="normalize-space(.//publisher-loc[1])"/>
          </xsl:if>
          <xsl:if test=".//edition[1]">
            <xsl:text>, </xsl:text>
            <xsl:value-of select="normalize-space(.//edition[1])"/>
            <xsl:text> ed.</xsl:text>
          </xsl:if>
          <xsl:apply-templates select="node()[not(self::person-group or self::name or self::string-name or self::article-title or self::source or self::year or self::volume or self::fpage or self::lpage or self::publisher-name or self::publisher-loc or self::edition)]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>

  <xsl:template match="element-citation//string-name | mixed-citation//string-name | nlm-citation//string-name"/>
  <xsl:template match="element-citation//surname | mixed-citation//surname | nlm-citation//surname"/>
  <xsl:template match="element-citation//given-names | mixed-citation//given-names | nlm-citation//given-names"/>
  <xsl:template match="element-citation//article-title | mixed-citation//article-title | nlm-citation//article-title"/>
  <xsl:template match="element-citation//source | mixed-citation//source | nlm-citation//source"/>
  <xsl:template match="element-citation//year | mixed-citation//year | nlm-citation//year"/>
  <xsl:template match="element-citation//volume | mixed-citation//volume | nlm-citation//volume"/>
  <xsl:template match="element-citation//fpage | mixed-citation//fpage | nlm-citation//fpage"/>
  <xsl:template match="element-citation//lpage | mixed-citation//lpage | nlm-citation//lpage"/>
  <xsl:template match="element-citation//publisher-name | mixed-citation//publisher-name | nlm-citation//publisher-name"/>
  <xsl:template match="element-citation//publisher-loc | mixed-citation//publisher-loc | nlm-citation//publisher-loc"/>
  <xsl:template match="element-citation//edition | mixed-citation//edition | nlm-citation//edition"/>
  <xsl:template match="person-group"/>

  <xsl:template match="sc">
    <span style="font-variant: small-caps;">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template match="named-content">
    <xsl:choose>
      <xsl:when test="@content-type='term' or @xlink:href">
        <a class="xref term-ref">
          <xsl:if test="@xlink:href">
            <xsl:attribute name="href"><xsl:value-of select="@xlink:href"/></xsl:attribute>
          </xsl:if>
          <xsl:text> </xsl:text>
          <xsl:apply-templates/>
          <xsl:text> </xsl:text>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <span class="named-content">
          <xsl:text> </xsl:text>
          <xsl:apply-templates/>
          <xsl:text> </xsl:text>
        </span>
      </xsl:otherwise>
    </choose>
  </xsl:template>

  <xsl:template match="std">
    <span class="std-ref">
      <xsl:text> </xsl:text>
      <xsl:apply-templates/>
      <xsl:text> </xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="std-id">
  </xsl:template>

  <xsl:template match="std-ref[not(parent::std-meta)]">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>

  <xsl:template match="xref">
    <xsl:choose>
      <xsl:when test="@rid and normalize-space(@rid) != ''">
        <a class="xref" href="#{@rid}">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </choose>
  </xsl:template>

  <xsl:template match="ext-link">
    <a class="ext-link" target="_blank" rel="noopener noreferrer">
      <xsl:attribute name="href">
        <xsl:value-of select="@xlink:href | @href"/>
      </xsl:attribute>
      <xsl:text> </xsl:text>
      <xsl:apply-templates/>
      <xsl:text> </xsl:text>
    </a>
  </xsl:template>

  <xsl:template match="kwd-group">
    <div class="kwd-group">
      <xsl:if test="title">
        <strong><xsl:value-of select="title"/></strong>
      </xsl:if>
      <xsl:if test="not(title)">
        <strong>Keywords: </strong>
      </xsl:if>
      <xsl:apply-templates select="*[not(self::title)]"/>
    </div>
  </xsl:template>

  <xsl:template match="kwd">
    <span class="kwd">
      <xsl:apply-templates/>
    </span>
    <xsl:if test="position() != last()">, </xsl:if>
  </xsl:template>

  <xsl:template match="contrib-group">
    <div class="contrib-group">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="contrib | author">
    <div class="contrib">
      <xsl:apply-templates select="name | collab"/>
      <xsl:apply-templates select="aff | address"/>
    </div>
  </xsl:template>

  <xsl:template match="name">
    <strong>
      <xsl:if test="prefix">
        <xsl:value-of select="prefix"/><xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="given-names">
        <xsl:value-of select="given-names"/><xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="surname">
        <xsl:value-of select="surname"/>
      </if>
      <xsl:if test="suffix">
        <xsl:text> </xsl:text><xsl:value-of select="suffix"/>
      </xsl:if>
    </strong>
  </xsl:template>

  <xsl:template match="aff | address">
    <div class="aff">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="collab">
    <div class="collab">
      <strong><xsl:apply-templates/></strong>
    </div>
  </xsl:template>

  <xsl:template match="ack">
    <section class="ack">
      <xsl:if test="title">
        <xsl:apply-templates select="title"/>
      </xsl:if>
      <xsl:if test="not(title)">
        <h3>Acknowledgments</h3>
      </xsl:if>
      <xsl:apply-templates select="*[not(self::title)]"/>
    </section>
  </xsl:template>

  <xsl:template match="app | app-group">
    <section class="app">
      <xsl:if test="@id">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </section>
  </xsl:template>

  <xsl:template match="annex-type">
    <p class="annex-type">
      (<xsl:apply-templates/>)
    </p>
  </xsl:template>

  <xsl:template match="app/title">
    <h2 class="annex-title">
      <xsl:if test="preceding-sibling::label">
        <xsl:value-of select="preceding-sibling::label"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
    </h2>
  </xsl:template>

  <xsl:template match="supp">
    <div class="supp">
      <xsl:if test="@id">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="alt-text | long-desc">
    <span style="display:none;">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="text()[not(ancestor::preformat or ancestor::code or ancestor::pre)]">
    <xsl:choose>
      <xsl:when test="ancestor::p or ancestor::ref or ancestor::element-citation or ancestor::mixed-citation or ancestor::nlm-citation or ancestor::td or ancestor::th">
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:if test="position() != last() and normalize-space(.) != ''">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:when test="ancestor::title or ancestor::h1 or ancestor::h2 or ancestor::h3 or ancestor::h4 or ancestor::h5 or ancestor::h6 or ancestor::main-title or ancestor::full">
        <xsl:value-of select="."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space(.)"/>
        <xsl:if test="position() != last() and normalize-space(.) != ''">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:otherwise>
    </choose>
  </xsl:template>

  <xsl:template match="preformat//text() | code//text() | pre//text()">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="*" priority="-1">
    <div>
      <xsl:if test="@id">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

</xsl:stylesheet>