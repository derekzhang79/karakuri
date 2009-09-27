/*
 *  Karakuri_Types.h
 *  Karakuri Prototype
 *
 *  Created by numata on 09/07/18.
 *  Copyright 2009 Satoshi Numata. All rights reserved.
 *
 */

#pragma once

#include <Karakuri/KarakuriString.h>

#include <string>


struct KRVector2D;
struct KRSize2D;


/*!
    @class KRObject
    @group Game Foundation
    @abstract Karakuri Framework 内のすべてのクラスの基底クラスとなるクラスです。
 */
typedef struct KRObject {
    KRObject();
    
    /*!
        @task デバッグのサポート
     */
    
    /*!
        @method c_str
        このクラスの内容を表すC言語文字列をリターンします。
     */
    const char *c_str() const;

    /*!
        @method to_s
        このクラスの内容を表す C++ 文字列をリターンします。
     */
    virtual std::string to_s() const;
} KRObject;


/*!
    @struct KRRect2D
    @group  Game Foundation
    @abstract 位置およびサイズで定義される矩形を表すための構造体です。
 */
typedef struct KRRect2D : public KRObject {
    
    /*!
        @var x
        矩形の位置のX座標です。
     */
    float x;

    /*!
        @var y
        矩形の位置のY座標です。
     */
    float y;

    /*!
        @var width
        矩形の横幅です。
     */
    float width;

    /*!
        @var height
        矩形の高さです。
     */
    float height;
    
    /*!
        @task コンストラクタ
     */
    
    /*!
        @method KRRect2D
        位置が (0, 0) であり、幅と高さが両方とも 0 の矩形を作成します。
     */
    KRRect2D();

    /*!
        @method KRRect2D
        位置と幅と高さを指定してこの矩形を作成します。
     */
    KRRect2D(float _x, float _y, float _width, float _height);
    
    /*!
        @method KRRect2D
        位置とサイズを指定してこの矩形を作成します。
     */
    KRRect2D(const KRVector2D& _origin, const KRVector2D& _size);
    
    /*!
        @method KRRect2D
        与えられた矩形をコピーして、この矩形を作成します。
     */
    KRRect2D(const KRRect2D& _rect);

    
    /*!
        @task 重なり判定のための関数
     */
    
    /*!
        @method contains
        この矩形が与えられた座標を含むかどうかをリターンします。
     */
    bool    contains(float _x, float _y) const;

    /*!
        @method contains
        この矩形が与えられた座標を含むかどうかをリターンします。
     */
    bool    contains(const KRVector2D& pos) const;
    
    /*!
        @method contains
        この矩形が、与えられた位置座標とサイズを元にした矩形を完全に含むかどうかをリターンします。
     */
    bool    contains(float _x, float _y, float _width, float _height) const;

    /*!
        @method contains
        この矩形が与えられた矩形を完全に含むかどうかをリターンします。
     */
    bool    contains(const KRRect2D& rect) const;    
    
    /*!
        @method intersects
        与えられた位置座標とサイズを元にした矩形とこの矩形が重なっているかどうかをリターンします。
     */
    bool    intersects(float _x, float _y, float _width, float _height) const;
    
    /*!
        @method intersects
        与えられた矩形とこの矩形が重なっているかどうかをリターンします。
     */
    bool    intersects(const KRRect2D& rect) const;

    
    /*!
        @task ジオメトリ計算のための関数
     */
    
    /*!
        @method getCenterPos
        この矩形の中心位置の座標をリターンします。
     */
    KRVector2D getCenterPos() const;

    /*!
        @method getIntersection
        この矩形と与えられた矩形との共通部分を表す矩形をリターンします。
     */
    KRRect2D    getIntersection(const KRRect2D& rect) const;

    /*!
        @method getMaxX
        この矩形を構成する最大のX座標をリターンします。
     */
    float getMaxX() const;
    
    /*!
        @method getMaxY
        この矩形を構成する最大のY座標をリターンします。
     */
    float getMaxY() const;

    /*!
        @method getMinX
        この矩形を構成する最小のX座標をリターンします。
     */
    float getMinX() const;

    /*!
        @method getMinY
        この矩形を構成する最小のY座標をリターンします。
     */
    float getMinY() const;
    
    /*!
        @method getOrigin
        X座標・Y座標がともに最小となるこの矩形上の座標をリターンします。
     */
    KRVector2D getOrigin() const;

    /*!
        @method getSize
        この矩形のサイズをリターンします。
     */
    KRVector2D getSize() const;
    
    /*!
        @method getUnion
        この矩形と与えられた矩形との結合部分を表す矩形をリターンします。
     */
    KRRect2D    getUnion(const KRRect2D& rect) const;    
    
    /*!
        @task 演算子のオーバーライド
     */
    
    /*!
        @method operator==
     */
    bool    operator==(const KRRect2D& rect) const;

    /*!
        @method operator!=
     */
    bool    operator!=(const KRRect2D& rect) const;
    
    static KRRect2D makeIntersection(const KRRect2D& src1, const KRRect2D& src2);   KARAKURI_FRAMEWORK_INTERNAL_USE_ONLY
    static KRRect2D makeUnion(const KRRect2D& src1, const KRRect2D& src2);          KARAKURI_FRAMEWORK_INTERNAL_USE_ONLY
    
    virtual std::string to_s() const;
    
} KRRect2D;


/*!
    @struct KRVector2D
    @group  Game Foundation
    @abstract 2次元ベクトルを表すための構造体です。
    点情報、サイズ情報を表すためにも使われます。
 */
typedef struct KRVector2D : public KRObject {
    
    /*!
        @var    x
        @abstract   このベクトルのX成分を表す数値です。
     */
    float   x;

    /*!
        @var    y
        @abstract   このベクトルのY成分を表す数値です。
     */
    float   y;

    /*!
        @task コンストラクタ
     */
    
    /*!
        @method KRVector2D
        このベクトルを、x=0.0f, y=0.0f で初期化します。
     */
    KRVector2D();

    /*!
        @method KRVector2D
        @param _x   X成分
        @param _y   Y成分
        このベクトルを、与えられた2つの数値で初期化します。
     */
    KRVector2D(float _x, float _y);
    
    /*!
        @method KRVector2D
        与えられたベクトルをコピーして、このベクトルを初期化します。
     */
    KRVector2D(const KRVector2D& vec);
    
    /*!
        @task 幾何計算のための関数
     */
    
    /*!
        @method angle
        このベクトルと与えられたベクトルが成す角度をリターンします。
     */
    float   angle(const KRVector2D &vec) const;    
    
    /*!
        @method innerProduct
        与えられたベクトルを右辺値として、このベクトルとの内積を計算します。
     */
    float innerProduct(const KRVector2D& vec) const;

    /*!
        @method length
        このベクトルの長さをリターンします。
     */
    float   length() const;

    /*!
        @method lengthSq
        このベクトルの長さの2乗をリターンします。
     */
    float   lengthSq() const;
    
    /*!
        @method normalize
        このベクトルを、長さ1のベクトルに正規化します。
     */
    KRVector2D &normalize();
    
    /*!
        @method outerProduct
        与えられたベクトルを右辺値として、このベクトルとの外積を計算します。
     */
    float outerProduct(const KRVector2D& vec) const;
    
    
    /*!
        @task 演算子のオーバーライド
     */
    
    /*!
        @method operator+
     */
    KRVector2D operator+(const KRVector2D& vec) const;

    /*!
        @method operator+=
     */
    KRVector2D& operator+=(const KRVector2D& vec);

    /*!
        @method operator-
     */
    KRVector2D operator-(const KRVector2D& vec) const;

    /*!
        @method operator-=
     */
    KRVector2D& operator-=(const KRVector2D& vec);

    /*!
        @method operator/
     */
    KRVector2D operator/(float value) const;

    /*!
        @method operator/=
     */
    KRVector2D& operator/=(float value);

    /*!
        @method operator*
     */
    KRVector2D operator*(float value) const;

    /*!
        @method operator*=
     */
    KRVector2D& operator*=(float value);
    
    /*!
        @method operator==
     */
    bool operator==(const KRVector2D& vec) const;

    /*!
        @method operator!=
     */
    bool operator!=(const KRVector2D& vec) const;
    
    /*!
        @method operator-
     */
    KRVector2D operator-() const;

    virtual std::string to_s() const;

} KRVector2D;


/*!
    @struct KRVector3D
    @group  Game Foundation
    @abstract 3次元ベクトルを表すための構造体です。
    点情報、サイズ情報を表すためにも使われます。
 */
typedef struct KRVector3D : public KRObject {
    
    /*!
        @var x
        このベクトルのX成分を表す数値です。
     */
    float   x;
    
    /*!
        @var y
        このベクトルのY成分を表す数値です。
     */    
    float   y;

    /*!
        @var z
        このベクトルのZ成分を表す数値です。
     */    
    float   z;
    
    /*!
        @task コンストラクタ
     */
    
    /*!
        @method KRVector3D
        このベクトルを、x=0.0f, y=0.0f, z=0.0f で初期化します。
     */
    KRVector3D();

    /*!
        @method KRVector3D
        このベクトルを、与えられた3つの数値で初期化します。
     */
    KRVector3D(float _x, float _y, float _z);

    /*!
        @method KRVector3D
        与えられたベクトルをコピーして、このベクトルを初期化します。
     */
    KRVector3D(const KRVector3D& vec);
    
    /*!
        @task 幾何計算のための関数
     */    
    
    /*!
        @method innerProduct
        与えられたベクトルを右辺値として、このベクトルとの内積を計算します。
     */
    float innerProduct(const KRVector3D& vec) const;

    /*!
        @method length
        このベクトルの長さをリターンします。
     */
    float   length() const;
    
    /*!
        @method lengthSq
        このベクトルの長さの2乗をリターンします。
     */
    float   lengthSq() const;
    
    /*!
        @method normalize
        このベクトルを、長さ1のベクトルに正規化します。
     */
    KRVector3D &normalize();
    
    /*!
        @method outerProduct
        与えられたベクトルを右辺値として、このベクトルとの外積を計算します。
     */
    KRVector3D outerProduct(const KRVector3D& vec) const;
    
    
    /*!
        @task 演算子のオーバーライド
     */
    
    /*!
        @method operator+
     */
    KRVector3D operator+(const KRVector3D& vec) const;

    /*!
        @method operator+=
     */
    KRVector3D& operator+=(const KRVector3D& vec);
    
    /*!
        @method operator-
     */
    KRVector3D operator-(const KRVector3D& vec) const;

    /*!
        @method operator-=
     */
    KRVector3D& operator-=(const KRVector3D& vec);
    
    /*!
        @method operator/
     */
    KRVector3D operator/(float value) const;

    /*!
        @method operator/=
     */
    KRVector3D& operator/=(float value);
    
    /*!
        @method operator*
     */
    KRVector3D operator*(float value) const;

    /*!
        @method operator*=
     */
    KRVector3D& operator*=(float value);
    
    /*!
        @method operator==
     */
    bool operator==(const KRVector3D& vec) const;

    /*!
        @method operator!=
     */
    bool operator!=(const KRVector3D& vec) const;
    
    /*!
        @method operator-
     */
    KRVector3D operator-() const;
    
    virtual std::string to_s() const;

} KRVector3D;


extern const KRRect2D         KRRect2DZero;
extern const KRVector2D       KRVector2DZero;
extern const KRVector2D       KRVector2DOne;
extern const KRVector3D       KRVector3DZero;


/*!
    @enum   KRLanguageType
    @group  Game Foundation
    @constant   KRLanguageEnglish   英語環境を表す定数です。
    @constant   KRLanguageJapanese  日本語環境を表す定数です。
    @abstract   言語環境を表すための型です。
    グローバル変数 KRLanguage で、ゲームが実行されている言語環境を表すために使われます。
 */
typedef enum KRLanguageType {
    KRLanguageEnglish,
    KRLanguageJapanese
} KRLanguageType;

/*!
    @var    gKRLanguage
    @group  Game Foundation
    @abstract 現在の言語環境を表す変数です。
    <p>該当する環境定数が KRLanguageType 列挙型に見つからない場合には、自動的に KRLanguageEnglish が設定されます。</p>
    <p>以下のようにして利用します。</p>
    <blockquote class="code"><pre>std::string text = "English Text";<br />
    if (gKRLanguage == KRLanguageJapanese) {<br />
    &nbsp;&nbsp;&nbsp;&nbsp;text = "日本語のテキスト";<br />
    }</pre></blockquote>
 */
extern KRLanguageType   gKRLanguage;



