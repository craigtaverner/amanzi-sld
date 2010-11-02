<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor xmlns:xlink="http://www.w3.org/1999/xlink" xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd" xmlns:ogc="http://www.opengis.net/ogc" version="1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.opengis.net/sld">
    <NamedLayer>
        <Name>Example</Name>
        <UserStyle>
            <Name>Example</Name>
            <!-- Pure-XML DSL -->
            <FeatureTypeStyle>
                <Rule>
                    <LineSymbolizer>
                        <Stroke>
                            <CssParameter name="stroke">#dddddd</CssParameter>
                            <CssParameter name="stroke-width">1</CssParameter>
                        </Stroke>
                    </LineSymbolizer>
                </Rule>
            </FeatureTypeStyle>
            <!-- Simple Line DSL -->
            <FeatureTypeStyle>
                <Rule>
                    <LineSymbolizer>
                        <Stroke>
                            <CssParameter name="stroke-width">2</CssParameter>
                            <CssParameter name="stroke">#dddddd</CssParameter>
                        </Stroke>
                    </LineSymbolizer>
                </Rule>
            </FeatureTypeStyle>
            <!-- Line with Filter, using XML DSL -->
            <FeatureTypeStyle>
                <Rule>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:Function name="geometryType">
                                <ogc:PropertyName>the_geom</ogc:PropertyName>
                            </ogc:Function>
                            <ogc:Literal>Polygon</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#aaaaaa</CssParameter>
                            <CssParameter name="fill-opacity">0.4</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#ffe0e0</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
            </FeatureTypeStyle>
            <!-- Line with Filter, using SLD DSL -->
            <FeatureTypeStyle>
                <Rule>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:Function name="geometryType">
                                <ogc:PropertyName>the_geom</ogc:PropertyName>
                            </ogc:Function>
                            <ogc:Literal>LineString</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <LineSymbolizer>
                        <Stroke>
                            <CssParameter name="stroke-width">2</CssParameter>
                            <CssParameter name="stroke">#dddddd</CssParameter>
                        </Stroke>
                    </LineSymbolizer>
                </Rule>
            </FeatureTypeStyle>
            <!-- Polygon with Filter, using SLD DSL -->
            <FeatureTypeStyle>
                <Rule>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:Function name="geometryType">
                                <ogc:PropertyName>the_geom</ogc:PropertyName>
                            </ogc:Function>
                            <ogc:Literal>Polygon</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill-opacity">0.4</CssParameter>
                            <CssParameter name="fill">#aaaaaa</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke-width">2</CssParameter>
                            <CssParameter name="stroke">#dddddd</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
            </FeatureTypeStyle>
            <!-- Polygon with Filter, using SLD DSL, and more compact polygon filtering syntax -->
            <FeatureTypeStyle>
                <Rule>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:Function name="geometryType">
                                <ogc:PropertyName>the_geom</ogc:PropertyName>
                            </ogc:Function>
                            <ogc:Literal>Polygon</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill-opacity">0.4</CssParameter>
                            <CssParameter name="fill">#aaaaaa</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke-width">2</CssParameter>
                            <CssParameter name="stroke">#dddddd</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
            </FeatureTypeStyle>
            <!-- Polygon with complex Filter -->
            <FeatureTypeStyle>
                <Rule>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsEqualTo>
                                <ogc:Function name="geometryType">
                                    <ogc:PropertyName>the_geom</ogc:PropertyName>
                                </ogc:Function>
                                <ogc:Literal>Polygon</ogc:Literal>
                            </ogc:PropertyIsEqualTo>
                            <ogc:Or>
                                <ogc:PropertyIsNull>
                                    <ogc:PropertyName>highway</ogc:PropertyName>
                                </ogc:PropertyIsNull>
                                <ogc:Not>
                                    <ogc:PropertyIsNull>
                                        <ogc:PropertyName>waterway</ogc:PropertyName>
                                    </ogc:PropertyIsNull>
                                </ogc:Not>
                                <ogc:PropertyIsEqualTo>
                                    <ogc:PropertyName>natural</ogc:PropertyName>
                                    <ogc:Literal>water</ogc:Literal>
                                </ogc:PropertyIsEqualTo>
                            </ogc:Or>
                        </ogc:And>
                    </ogc:Filter>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill-opacity">0.4</CssParameter>
                            <CssParameter name="fill">#aaaaaa</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke-width">2</CssParameter>
                            <CssParameter name="stroke">#dddddd</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
            </FeatureTypeStyle>
            <!-- Polygon with combined simple and complex Filter -->
            <FeatureTypeStyle>
                <Rule>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:PropertyIsEqualTo>
                                <ogc:Function name="geometryType">
                                    <ogc:PropertyName>the_geom</ogc:PropertyName>
                                </ogc:Function>
                                <ogc:Literal>Polygon</ogc:Literal>
                            </ogc:PropertyIsEqualTo>
                            <ogc:Or>
                                <ogc:PropertyIsNull>
                                    <ogc:PropertyName>highway</ogc:PropertyName>
                                </ogc:PropertyIsNull>
                                <ogc:Not>
                                    <ogc:PropertyIsNull>
                                        <ogc:PropertyName>waterway</ogc:PropertyName>
                                    </ogc:PropertyIsNull>
                                </ogc:Not>
                                <ogc:PropertyIsEqualTo>
                                    <ogc:PropertyName>natural</ogc:PropertyName>
                                    <ogc:Literal>water</ogc:Literal>
                                </ogc:PropertyIsEqualTo>
                            </ogc:Or>
                        </ogc:And>
                    </ogc:Filter>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill-opacity">0.4</CssParameter>
                            <CssParameter name="fill">#aaaaaa</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke-width">2</CssParameter>
                            <CssParameter name="stroke">#dddddd</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
            </FeatureTypeStyle>
            <!-- Multiple symbolizers and complex filter -->
            <FeatureTypeStyle>
                <Rule>
                    <ogc:Filter>
                        <ogc:And>
                            <ogc:Not>
                                <ogc:PropertyIsNull>
                                    <ogc:PropertyName>highway</ogc:PropertyName>
                                </ogc:PropertyIsNull>
                            </ogc:Not>
                            <ogc:Or>
                                <ogc:PropertyIsEqualTo>
                                    <ogc:PropertyName>highway</ogc:PropertyName>
                                    <ogc:Literal>secondary</ogc:Literal>
                                </ogc:PropertyIsEqualTo>
                                <ogc:PropertyIsEqualTo>
                                    <ogc:PropertyName>highway</ogc:PropertyName>
                                    <ogc:Literal>tertiary</ogc:Literal>
                                </ogc:PropertyIsEqualTo>
                            </ogc:Or>
                        </ogc:And>
                    </ogc:Filter>
                    <LineSymbolizer>
                        <Stroke>
                            <CssParameter name="stroke-width">7</CssParameter>
                            <CssParameter name="stroke">#303030</CssParameter>
                        </Stroke>
                    </LineSymbolizer>
                    <LineSymbolizer>
                        <Stroke>
                            <CssParameter name="stroke-width">5</CssParameter>
                            <CssParameter name="stroke">#e0e0ff</CssParameter>
                        </Stroke>
                    </LineSymbolizer>
                </Rule>
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>
